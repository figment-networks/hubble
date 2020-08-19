class Livepeer::SubscriptionsController < Livepeer::BaseController
  before_action :require_user
  before_action :require_chain
  before_action :require_delegator_list
  before_action :require_subscription

  before_action :transform_event_kinds, only: :create

  def index
    page_title %{Event Subscription for Delegator List "#{@delegator_list.name}"}
  end

  def create
    @subscription.assign_attributes(alert_subscription_params)

    existed = @subscription.persisted?
    if !existed
      @subscription.assign_attributes(last_daily_at: 1.day.ago.end_of_day, last_instant_at: Time.now.utc)
    end

    if @subscription.save
      flash[:notice] = existed ? 'Subscription updated.' : 'Subscribed to events for this delegator list.'
      redirect_to action: :index
    else
      if !@subscription.subscribes_to_something?
        @subscription.destroy!
        flash[:notice] = 'No alerts selected. Subscription removed.'
        redirect_to action: :index
      else
        render :index
      end
    end
  end

  private

  def require_delegator_list
    @delegator_list = current_user.livepeer_delegator_lists.for(@chain).find(params[:delegator_list_id])
  end

  def require_subscription
    @subscription = current_user.alert_subscriptions.where(alertable: @delegator_list).first_or_initialize
  end

  def transform_event_kinds
    params[:alert_subscription] ||= ActionController::Parameters.new({})
    kinds_hash = params[:alert_subscription][:event_kinds] || {}
    kinds = kinds_hash.keys.select { |k| kinds_hash[k] == 'on' }
    params[:alert_subscription][:event_kinds] = kinds
  end

  def alert_subscription_params
    params.require(:alert_subscription).permit(:wants_daily_digest, event_kinds: [])
  end
end
