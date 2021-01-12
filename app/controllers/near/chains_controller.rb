class Near::ChainsController < Near::BaseController
  def show
    @status              = client.status
    @validators          = client.validators
    @staked_amount       = @validators.sum(&:stake)
    @block               = client.current_block
    @block_times         = client.block_times
    @block_intervals     = serialized_block_intervals
    @validator_intervals = serialized_validator_intervals

    page_title 'Overview'
    meta_description 'Validators'
  end

  def search
    flash[:warning] = 'Sorry, search on this network is currently unavailable!'
    redirect_to near_chain_path(@chain)
  end

  private

  def block_stats
    @block_stats ||= client.block_stats.reverse
  end

  def serialized_block_intervals
    block_stats.map(&:block_time_point)
  end

  def serialized_validator_intervals
    block_stats.map(&:validators_count_point)
  end
end
