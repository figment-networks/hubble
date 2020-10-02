class Oasis::BaseController < Indexer::BaseController
  private

  def set_behind_chain_alert
    @latest_block = @chain.client.current_block
    @is_synced = @latest_block && @latest_block.time > 6.minutes.ago
  rescue Common::IndexerClient::Error => error
    @error = error
  end
end
