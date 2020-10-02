class Cosmoslike::BaseController < ApplicationController
  before_action :find_chain
  before_action :set_behind_chain_alert

  protected

  def set_behind_chain_alert
    return unless @chain

    @latest_block = @chain.blocks.first
    @latest_sync = @chain.sync_logs.completed.first || @chain.daily_sync_logs.first
    @is_syncing = @latest_sync && @latest_sync.timestamp > 6.minutes.ago
  end

  def find_chain
    @namespace = self.class.name.split('::').first.constantize
    @chain = @namespace::Chain.alive.find_by!(slug: (params[:chain_id] || params[:id]).try(:downcase))
  end
end
