require 'indexer/resources/baker'
require 'indexer/resources/cycle'

module Tezos
  class BakersController < BaseController
    def show
      @current_cycle = Indexer::Cycle.retrieve
      @baker = Indexer::Baker.retrieve(params[:id])
      @cycle_reports = @baker.baking_stats_history.to_a.reverse
      @pagy = Pagy.new(count: @cycle_reports.length, page: params[:page])
      @cycle_reports = @cycle_reports[@pagy.offset, @pagy.items].to_h

      alertable = AlertableAddress.find_by(chain: @chain, address: @baker.address)
      @subscription = current_user.alert_subscriptions.find_by(alertable: alertable) if current_user
    end
  end
end
