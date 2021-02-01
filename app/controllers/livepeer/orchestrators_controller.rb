class Livepeer::OrchestratorsController < Livepeer::BaseController
  before_action :require_chain

  def show
    @orchestrator = @chain.orchestrators.find_by!(address: params[:address])

    @events = @orchestrator.events.order(timestamp: :desc).includes(:round)
    @delegators = @orchestrator.delegators.order(pending_stake: :desc)

    page_title "Orchestrator #{@orchestrator.name_or_address}"
    meta_description 'Event History, Reward Cut, Fee Share and Total Stake'
  end
end
