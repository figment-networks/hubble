class Livepeer::RoundsController < Livepeer::BaseController
  before_action :require_chain

  def show
    @round = @chain.rounds.find_by!(number: params[:number])
    @pools = @round.pools.order(total_stake: :desc)
    @orchestrators = @chain.orchestrators.where(address: @pools.map(&:orchestrator_address)).to_a

    page_title "Pools for Round #{@round.number}"
    meta_description 'Pools'
  end
end
