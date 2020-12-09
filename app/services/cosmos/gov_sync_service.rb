class Cosmos::GovSyncService < Cosmoslike::GovSyncService
  private

  def build_proposal(proposal)
    if @chain.sdk_gte?('0.40.0')
      proposal_id = proposal['proposal_id']
      return if proposal_id == '0' || proposal['proposal_content'].nil?

      h = {
        ext_id: proposal_id.to_i,
        proposal_type: proposal['proposal_type'],
        proposal_status: proposal['status'] || proposal['proposal_status'],
        title: proposal['proposal_content']['value']['title'],
        description: proposal['proposal_content']['value']['description'],
        submit_time: DateTime.parse(proposal['submit_time']),
        deposit_end_time: DateTime.parse(proposal['deposit_end_time']),
        voting_start_time: DateTime.parse(proposal['voting_start_time']),
        voting_end_time: DateTime.parse(proposal['voting_end_time']),
        total_deposit: proposal['total_deposit']
      }.stringify_keys

      merge_voting_times(proposal['voting_start_time'], proposal['voting_end_time'], h)

      h

    elsif @chain.sdk_gte?('0.37.0')
      return if proposal['id'] == '0' || proposal['content'].nil?

      h = {
        ext_id: proposal['id'].to_i,
        proposal_type: proposal['content']['type'],
        proposal_status: proposal['proposal_status'],
        title: proposal['content']['value']['title'],
        description: proposal['content']['value']['description'],
        additional_data: proposal['content']['value'].except('title', 'description'),
        submit_time: DateTime.parse(proposal['submit_time']),
        deposit_end_time: DateTime.parse(proposal['deposit_end_time']),
        total_deposit: proposal['total_deposit']
      }.stringify_keys

      merge_voting_times(proposal['voting_start_time'], proposal['voting_end_time'], h)

      h

    elsif @chain.sdk_gte?('0.36.0')
      return nil if proposal['id'] == '0' || proposal['content'].nil?

      {
        ext_id: proposal['id'].to_i,
        proposal_type: proposal['content']['type'],
        proposal_status: proposal['proposal_status'],
        title: proposal['content']['value']['title'],
        description: proposal['content']['value']['description'],
        submit_time: DateTime.parse(proposal['submit_time']),
        deposit_end_time: DateTime.parse(proposal['deposit_end_time']),
        voting_start_time: DateTime.parse(proposal['voting_start_time']),
        voting_end_time: DateTime.parse(proposal['voting_end_time']),
        total_deposit: proposal['total_deposit']
      }.stringify_keys

    elsif @chain.sdk_gte?('0.34')
      return nil if proposal['proposal_id'] == '0' || proposal['proposal_content'].nil?

      {
        ext_id: proposal['proposal_id'].to_i,
        proposal_type: proposal['proposal_type'],
        proposal_status: proposal['proposal_status'],
        title: proposal['proposal_content']['value']['title'],
        description: proposal['proposal_content']['value']['description'],
        submit_time: DateTime.parse(proposal['submit_time']),
        deposit_end_time: DateTime.parse(proposal['deposit_end_time']),
        voting_start_time: DateTime.parse(proposal['voting_start_time']),
        voting_end_time: DateTime.parse(proposal['voting_end_time']),
        total_deposit: proposal['total_deposit']
      }.stringify_keys

    else
      proposal = proposal['value']

      {
        ext_id: proposal['proposal_id'].to_i,
        proposal_type: proposal['proposal_type'],
        proposal_status: proposal['proposal_status'],
        title: proposal['title'],
        description: proposal['description'],
        submit_time: DateTime.parse(proposal['submit_time']),
        deposit_end_time: DateTime.parse(proposal['deposit_end_time']),
        voting_start_time: DateTime.parse(proposal['voting_start_time']),
        voting_end_time: DateTime.parse(proposal['voting_end_time']),
        total_deposit: proposal['total_deposit']
      }.stringify_keys
    end
  end

  def merge_voting_times(start_date, end_date, h)
    if DateTime.parse(start_date).to_i > 0
      h.merge!({
                 voting_start_time: DateTime.parse(start_date),
                 voting_end_time: DateTime.parse(end_date)
               }).stringify_keys
    end
  end
end
