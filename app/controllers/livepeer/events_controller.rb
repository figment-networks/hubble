class Livepeer::EventsController < Livepeer::BaseController
  include Pagy::Backend

  before_action :require_chain

  before_action :set_default_page_title
  before_action :set_default_meta_description

  def index
    if orchestrator.present?
      @pagy, @events = pagy(orchestrator.events.order(timestamp: :desc).includes(:round))

      page_title orchestrator.name_or_address
      meta_description orchestrator.name_or_address
    else
      @pagy, @events = pagy(@chain.events.order(timestamp: :desc).includes(round: :chain))
    end
  end

  def show
    @event = @chain.events.find(params[:id])
    @orchestrator = @event.orchestrator

    page_title @event.kind_string.humanize
    meta_description @event.kind_string.humanize
  end

  private

  def orchestrator
    @orchestrator ||= @chain.orchestrators.find_by(address: params[:orchestrator_address])
  end
end
