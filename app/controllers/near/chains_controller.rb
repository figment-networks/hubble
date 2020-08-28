class Near::ChainsController < Near::BaseController
  def show
    @status              = client.status
    @validators          = client.validators
    @block               = client.current_block
    @block_times         = client.block_times
    @block_intervals     = serialized_block_intervals
    @validator_intervals = serialized_validator_intervals

    page_title 'Overview'
    meta_description 'Validators'
  end

  def search
    flash[:warning] = "Sorry, search on this network is currently unavailable!"
    redirect_to near_chain_path(@chain)
  end

  private

  def serialized_block_intervals
    client.block_times_interval.reverse.map(&:point)
  end

  def serialized_validator_intervals
    client.validator_times_interval.reverse.map(&:point)
  end
end
