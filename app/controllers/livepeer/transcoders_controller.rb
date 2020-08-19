class Livepeer::TranscodersController < Livepeer::BaseController
  before_action :require_chain

  def show
    @transcoder = @chain.transcoders.find_by!(address: params[:address])
    @events = @transcoder.events.order(timestamp: :desc).includes([:round])

    page_title "Orchestrator #{@transcoder.name_or_address}"
    meta_description 'Event History, Reward Cut, Fee Share and Total Stake'
  end
end
