class Livepeer::RoundsController < Livepeer::BaseController
  before_action :require_chain

  def show
    @round = @chain.rounds.find_by!(number: params[:number])
    @pools = @round.pools.order(total_stake: :desc)

    page_title "Pools for round #{@round.number}"
    meta_description 'Pools'
  end
end
