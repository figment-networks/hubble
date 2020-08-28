class Livepeer::DelegatorListsController < Livepeer::BaseController
  before_action :require_user
  before_action :require_chain

  before_action :set_default_page_title
  before_action :set_default_meta_description

  def index
    @delegator_lists = delegator_lists.order(:id).includes(:alert_subscriptions)
  end

  def new
    @delegator_list = delegator_lists.new(addresses: [''])
    render :edit
  end

  def create
    @delegator_list = delegator_lists.new(delegator_list_params)

    if @delegator_list.save
      redirect_to action: :index
    else
      render :edit
    end
  end

  def show
    redirect_to action: :edit
  end

  def edit
    @delegator_list = delegator_lists.find(params[:id])
  end

  def update
    @delegator_list = delegator_lists.find(params[:id])

    if @delegator_list.update(delegator_list_params)
      redirect_to action: :index
    else
      render :edit
    end
  end

  def destroy
    delegator_list = delegator_lists.find(params[:id])
    delegator_list.destroy!

    redirect_to action: :index
  end

  private

  def delegator_lists
    current_user.livepeer_delegator_lists.for(@chain)
  end

  def delegator_list_params
    params.require(:delegator_list).permit(:name, :email_alerts_enabled, addresses: [])
  end
end
