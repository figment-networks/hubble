class Mina::ChainsController < Mina::BaseController
  def show
    @status      = client.status
    @validators  = client.validators
    @pool        = @validators.sum(&:account_balance)
    @block       = client.current_block
    @block_times = client.block_times
    @block_stats = block_stats
    @tx_stats    = transactions_stats

    page_title 'Overview'
    meta_description 'Validators'
  end

  def search
    flash[:warning] = 'Sorry, search on this network is currently unavailable!'
    redirect_to mina_chain_path(@chain)
  end

  private

  def block_stats
    stats = client.block_stats(interval: 'h', period: 48)
    Mina::BlockStatsDecorator.new(@chain, stats)
  end

  def transactions_stats
    stats = client.transactions_stats(interval: 'd', period: 30)
    Mina::TransactionsStatsDecorator.new(@chain, stats)
  end
end
