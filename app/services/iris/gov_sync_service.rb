class Iris::GovSyncService < Cosmoslike::GovSyncService
  private

  def build_proposal(proposal)
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
  end
end
