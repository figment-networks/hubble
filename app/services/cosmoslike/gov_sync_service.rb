class Cosmoslike::GovSyncService
  def initialize(chain)
    @chain = chain
    @syncer = @chain.syncer(10_000)
  end

  def sync_params!
    ProgressReport.instance.start "Syncing Governance Params for #{@chain.network_name}/#{@chain.name}..."
    @chain.update governance: (@syncer.get_governance || {})
    ProgressReport.instance.report
  end

  def sync_pool!
    ProgressReport.instance.start "Syncing Community Pool for #{@chain.network_name}/#{@chain.name}..."

    pool = @syncer.get_community_pool
    pool&.map! do |balance|
      balance['amount'] = balance['amount'].to_f
      balance
    end
    @chain.update community_pool: pool

    ProgressReport.instance.report
  end

  def sync_token_stats!
    ProgressReport.instance.start "Syncing Token Stats for #{@chain.network_name}/#{@chain.name}..."

    staking_pool = @syncer.get_staking_pool
    @chain.update staking_pool: staking_pool

    ProgressReport.instance.report
  end

  def sync_proposals!
    return if !@chain.governance_params_synced?

    ProgressReport.instance.start "Syncing Governance Proposals for #{@chain.network_name}/#{@chain.name}..."

    tracked_proposal_ids = []

    ext_proposals = @syncer.get_proposals
    ext_proposals.try(:each) do |proposal|
      proposal_details = build_proposal(proposal)
      next if proposal_details.nil?

      tracked_proposal_ids << proposal_details['ext_id']

      begin
        working_proposal = @chain.governance_proposals.find_by(
          ext_id: proposal_details['ext_id']
        )

        if working_proposal
          if working_proposal.finalized?
            puts "Skipping finalized proposal: #{working_proposal.ext_id} - #{working_proposal.title}"
            next
          else
            puts "Updating existing proposal: #{working_proposal.ext_id} - #{working_proposal.title}"
            working_proposal.update(proposal_details)
          end
        else
          working_proposal = @chain.governance_proposals.create(proposal_details)
          puts "Synced new proposal: #{working_proposal.ext_id} - #{working_proposal.title}"
        end

        sync_governance_proposal_deposits(working_proposal)
        sync_governance_proposal_votes(working_proposal)
        sync_governance_proposal_tallies(working_proposal)

        if working_proposal.ended?
          proposal_finalized(working_proposal)
          working_proposal.update(finalized: true)
          puts "Finalized past proposal: #{working_proposal.ext_id} - #{working_proposal.title}"
        end
      end
    end

    to_purge = @chain.governance_proposals.where.not(ext_id: tracked_proposal_ids)
    if !ext_proposals.nil? && to_purge.any?
      puts "Purging old dead proposals: #{to_purge.map(&:ext_id)}"
      to_purge.map(&:destroy)
    end

    ProgressReport.instance.report
  end

  private

  def sync_governance_proposal_tallies(hubble_proposal)
    tally = @syncer.get_proposal_tally(hubble_proposal.ext_id)
    return if tally.nil?

    hubble_proposal.update(
      tally_result_yes: tally['yes'],
      tally_result_no: tally['no'],
      tally_result_abstain: tally['abstain'],
      tally_result_nowithveto: tally['no_with_veto']
    )
  end

  def sync_governance_proposal_deposits(hubble_proposal)
    deposits = @syncer.get_proposal_deposits(hubble_proposal.ext_id)
    return if deposits.nil?

    by_depositor = deposits.group_by { |dep| dep['depositer'] || dep['depositor'] }

    by_depositor.entries.each do |address, deposits|
      deposit = deposits.last
      account = @chain.accounts.find_or_create_by!(address: address)

      deposit['amount'].try(:each) do |deposit_amount|
        amount_denom = deposit_amount['denom']
        amount = deposit_amount['amount'].to_i

        deposit = @chain.namespace::Governance::Deposit.find_by(
          account: account,
          proposal: hubble_proposal
        )

        if deposit
          # ensure only 1 deposit for this account/proposal pair
          extras = @chain.namespace::Governance::Deposit.
            where(account: account, proposal: hubble_proposal).
            where('id != ?', deposit.id)
          if extras.any?
            puts "Purging #{extras.count} extra deposits for #{account.address} (#{account.address}/#{hubble_proposal.id})..."
            extras.map(&:destroy)
          end

          deposit.assign_attributes(amount_denom: amount_denom, amount: amount)
          if deposit.changed?
            puts "Deposit by #{account.address} on #{hubble_proposal.title} updated (#{deposit.changes})"
            deposit.save
          end
        else
          deposit = @chain.namespace::Governance::Deposit.create(
            account: account,
            proposal: hubble_proposal,
            amount_denom: amount_denom,
            amount: amount
          )
          puts "Deposit by #{account.address} recorded against #{hubble_proposal.title}"
        end

        if !deposit.valid? || !deposit.persisted?
          puts "Invalid deposit #{deposit_amount.inspect} for proposal #{hubble_proposal.title} -- #{deposit.errors.full_messages.join(', ')}"
        end
      end
    end
  end

  def sync_governance_proposal_votes(hubble_proposal)
    votes = @syncer.get_proposal_votes(hubble_proposal.ext_id)
    return if votes.nil?

    by_voter = votes.group_by { |vote| vote['voter'] }

    by_voter.entries.each do |address, votes|
      vote_data = votes.last
      option = vote_data['option']
      account = @chain.accounts.find_or_create_by!(address: address)

      vote = @chain.namespace::Governance::Vote.find_by(account: account, proposal: hubble_proposal)

      if vote
        # ensure only 1 vote for this account/proposal pair
        extras = @chain.namespace::Governance::Vote.
          where(account: account, proposal: hubble_proposal).
          where('id != ?', vote.id)
        if extras.any?
          puts "Purging #{extras.count} extra votes for #{account.address} (#{account.address}/#{hubble_proposal.id})..."
          extras.map(&:destroy)
        end

        vote.assign_attributes(option: option)
        if vote.changed?
          puts "Vote by #{account.address} on #{hubble_proposal.title} updated (#{vote.changes})"
          vote.save
        end
      else
        vote = @chain.namespace::Governance::Vote.create(
          account: account,
          proposal: hubble_proposal,
          option: option
        )
        puts "Vote (#{option}) by #{account.address} recorded against proposal #{hubble_proposal.title}"
      end

      if !vote.valid? || !vote.persisted?
        puts "Invalid vote #{vote_data.inspect} for proposal #{hubble_proposal.title} -- #{vote.errors.full_messages.join(', ')}"
      end
    end
  end

  def proposal_finalized(hubble_proposal)
    if hubble_proposal.voting_end_time.blank? || hubble_proposal.in_voting_period? || hubble_proposal.in_deposit_period?
      ext_proposals = @syncer.get_proposals
      suspect_proposal = ext_proposals.detect { |p| p['id'].to_s == hubble_proposal.ext_id.to_s }
      Rollbar.error(
        'Governance - illogical combination of voting_end_time and/or proposal_status.', proposal: suspect_proposal
      )
      puts 'Proposal reported for review - illogical combination of voting_end_time and/or proposal_status.'
    end
  end

  def build_proposal(_proposal)
    raise NotImplementedError, "Implement #build_proposal for #{self.class.name}"
  end
end
