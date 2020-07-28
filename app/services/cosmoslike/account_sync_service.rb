class Cosmoslike::AccountSyncService
  def initialize( chain )
    @chain = chain
  end

  def ensure_delegator_accounts!( validators: nil, return_accounts: false )
    ProgressReport.instance.start "Ensuring delegator accounts for #{@chain.network_name}/#{@chain.name}..."

    before = @chain.accounts.count

    validators ||= @chain.validators
    iterator_method = validators.respond_to?(:find_each) ? :find_each : :each

    accounts = []

    validators.public_send(iterator_method).with_index do |validator, i|
      accounts.concat get_delegator_accounts_for_validator( validator.owner )

      ProgressReport.instance.progress 0, i, validators.count - 1 do |current|
        "#{validator.owner} (#{i+1} / #{validators.count})"
      end
      ProgressReport.instance.benchmark i / validators.count.to_f
    end

    after = @chain.reload.accounts.count

    ProgressReport.instance.report( "Created #{after - before} new accounts." )

    return_accounts ? accounts : nil
  end

  private

  def get_delegator_accounts_for_validator( valoper )
    @chain.syncer.get_validator_delegations( valoper ).map do |delegation|
      @chain.accounts.find_or_create_by!( address: delegation['delegator_address'] )
    end +
    @chain.syncer.get_validator_unbonding_delegations( valoper ).map do |delegation|
      @chain.accounts.find_or_create_by!( address: delegation['delegator_address'] )
    end
  end
end
