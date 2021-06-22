class Cosmoslike::Governance::ProposalsController < Cosmoslike::BaseController
  def show
    @proposal = @chain.governance_proposals.find_by!(ext_id: params[:id])
    @tally_result = @chain.namespace::ProposalTallyDecorator.new(@proposal)
    @penalty = @chain.governance_params.tally_param_governance_penalty

    page_title @chain.network_name, @chain.name, @proposal.title
    meta_description @proposal.description.truncate(160)
  end
end
