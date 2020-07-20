class Oasis::BlocksController < Oasis::BaseController
  def show
    page_title 'Overview'

    @height = params[:id].to_i
    @block = @chain.client.block(@height)
    @validators = @chain.client.validators_by_height(@height)
    @transactions = @chain.client.transactions(@height)
    @voting_power = @validators.sum(&:total_shares)
  end
end
