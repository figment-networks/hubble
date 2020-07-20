require "indexer/resources/baker"
require "indexer/resources/cycle"
require "indexer/resources/event"

module Tezos
  class CyclesController < BaseController
    include Pagy::Backend

    def show
      if params[:query].present?
        @search = Search.new(query: params[:query])
        redirect_to tezos_baker_path(@search.results.first.id) if @search.results.length == 1
      else
        @cycle = Indexer::Cycle.retrieve(params[:id])
        @current_cycle = params[:id].nil? ? @cycle : Indexer::Cycle.retrieve()

        @bakers = Indexer::Baker.list

        # TODO: Need to add Subscription model
        # if current_user
        #   @subscribed_baker_ids = current_user.subscriptions.pluck(:baker_id)
        #   @subscribed_bakers = @bakers.select { |b| @subscribed_baker_ids.include?(b.id) }
        # else
          @subscribed_baker_ids = []
          @subscribed_bakers = []
        # end

        @other_bakers = if current_user
          @bakers.select { |b| @subscribed_baker_ids.exclude?(b.id) }
        else
          @bakers
        end

        @pagy = Pagy.new(count: @other_bakers.length, page: params[:page])
        @other_bakers = @other_bakers[@pagy.offset, @pagy.items]

        @events = Indexer::Event.list(cycle_id: (params[:id] || "current"), types: params[:types])

        page_title 'Tezos', "Mainnet", "Cycle #{@cycle.number}"
      end
    end
  end
end
