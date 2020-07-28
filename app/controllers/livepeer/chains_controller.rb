class Livepeer::ChainsController < Livepeer::BaseController
  def show
    @chain = Livepeer::Chain.find_by!(slug: params[:id])

    @transcoders = @chain.transcoders
    @latest_round = @chain.rounds.order(number: :desc).take

    page_title 'Overview'
    meta_description 'Orchestrators'
  end

  def search
    redirect_to action: :show
  end
end
