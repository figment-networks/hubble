class Kava::GovSyncService < Cosmoslike::GovSyncService
  private

  def build_proposal( proposal )
    if @chain.sdk_gte?( '0.38.0' )
      return nil if proposal['id'] == '0' || proposal['content'].nil?
      h = {
        ext_id: proposal['id'].to_i,
        proposal_type: proposal['content']['type'],
        proposal_status: proposal['proposal_status'],
        title: proposal['content']['value']['title'],
        description: proposal['content']['value']['description'],
        additional_data: proposal['content']['value'].except(*%w{ title description }),
        submit_time: DateTime.parse(proposal['submit_time']),
        deposit_end_time: DateTime.parse(proposal['deposit_end_time']),
        voting_start_time: DateTime.parse(proposal['voting_start_time']),
        voting_end_time: DateTime.parse(proposal['voting_end_time']),
        total_deposit: proposal['total_deposit']
      }

      # on 0.38 voting start and end times will be invalid
      # if voting hasn't yet started. also seems to affect old
      # proposals from a previous chain
      if h[:voting_start_time].year == 1
        h.delete :voting_start_time
        h.delete :voting_end_time
      end

      h.stringify_keys

    elsif @chain.sdk_gte?( '0.37.0' )
      return nil if proposal['id'] == '0' || proposal['content'].nil?
      {
        ext_id: proposal['id'].to_i,
        proposal_type: proposal['content']['type'],
        proposal_status: proposal['proposal_status'],
        title: proposal['content']['value']['title'],
        description: proposal['content']['value']['description'],
        additional_data: proposal['content']['value'].except(*%w{ title description }),
        submit_time: DateTime.parse(proposal['submit_time']),
        deposit_end_time: DateTime.parse(proposal['deposit_end_time']),
        voting_start_time: DateTime.parse(proposal['voting_start_time']),
        voting_end_time: DateTime.parse(proposal['voting_end_time']),
        total_deposit: proposal['total_deposit']
      }.stringify_keys

    elsif @chain.sdk_gte?( '0.36.0-rc1' )
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

    else
      return nil if proposal['proposal_id'] == '0' || proposal['proposal_content'].nil?
      {
        ext_id: proposal['proposal_id'].to_i,
        proposal_type: 'Text',
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

end
