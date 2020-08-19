class Livepeer::EventsController < Livepeer::BaseController
  include Pagy::Backend

  before_action :require_chain

  def index
    @pagy, @events = pagy(@chain.events.includes(:round))

    if params[:transcoder_address] && (@transcoder = @chain.transcoders.find_by(address: params[:transcoder_address]))
      @pagy, @events = pagy(@events.where(transcoder_address: @transcoder.address).includes(:round))
      page_title(@transcoder.name_or_address)
      meta_description(@transcoder.name_or_address)
    end

  end

  def show
    @event = @chain.events.find(params[:id])
    @transcoder = @event.transcoder
    page_title @event.page_title
    meta_description @event.page_title
  end
end
