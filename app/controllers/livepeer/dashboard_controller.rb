class Livepeer::DashboardController < Common::DashboardController
  prepend_before_action -> { @namespace = self.class.name.split('::').first.constantize }

  def index
    super
    @subscriptions = @chain.alert_subscriptions.where(user: current_user)
  end
end
