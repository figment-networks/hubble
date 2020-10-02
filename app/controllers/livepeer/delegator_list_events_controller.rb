class Livepeer::DelegatorListEventsController < Livepeer::BaseController
  include Pagy::Backend

  before_action :require_chain
  before_action :require_user

  before_action :set_default_page_title
  before_action :set_default_meta_description

  def index
    @delegator_list = delegator_lists.find(params[:delegator_list_id])
    @pagy, @events = pagy(@delegator_list.events.order(timestamp: :desc).includes(round: :chain))
  end

  private

  def delegator_lists
    current_user.livepeer_delegator_lists.for(@chain)
  end
end
