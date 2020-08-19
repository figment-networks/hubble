class Livepeer::DelegatorListEventsController < Livepeer::BaseController
  include Pagy::Backend

  before_action :require_chain
  before_action :require_user

  def index
    @delegator_list = current_user.livepeer_delegator_lists.for(@chain).find_by(id: params[:delegator_list_id])
    @pagy, @events = pagy(@delegator_list.events.includes([:round]))
  end
end
