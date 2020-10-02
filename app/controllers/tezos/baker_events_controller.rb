require 'indexer/resources/cycle'
require 'indexer/resources/event'

module Tezos
  class BakerEventsController < BaseController
    def index
      @cycle = Indexer::Cycle.retrieve(params[:cycle_id])
      @events = Indexer::Event.list(cycle_id: @cycle.number, page: params[:page])
      @pagy = Pagy.new(@events[:pagination].symbolize_keys)
    end
  end
end
