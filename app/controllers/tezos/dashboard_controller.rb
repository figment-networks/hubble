class Tezos::DashboardController < Common::DashboardController
  prepend_before_action -> { @namespace = self.class.name.split('::').first.constantize }
  layout 'application'

  def index
    super
    @subscriptions = @chain.alert_subscriptions.where(user: current_user)
  end
end
