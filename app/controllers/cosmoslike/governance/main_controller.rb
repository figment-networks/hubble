class Cosmoslike::Governance::MainController < Cosmoslike::BaseController
  def index
    @proposals = @chain.governance_proposals.ordered_by_submit_time

    page_title @chain.network_name, @chain.name, 'Governance Proposals & Results'
    meta_description "#{@chain.network_name} -- #{@chain.name} Governance Proposals: Title, Status, Date Submitted, and Proposal Parameters"
  end
end
