class Emoney::GovSyncService < Cosmoslike::GovSyncService
  private

  def build_proposal(proposal)
    return nil if proposal['id'] == '0' || proposal['content'].nil?

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

    if DateTime.parse(proposal['voting_start_time']).to_i > 0
      h.merge!({
                 voting_start_time: DateTime.parse(proposal['voting_start_time']),
                 voting_end_time: DateTime.parse(proposal['voting_end_time'])
               }).stringify_keys
    end

    h
  end
end
