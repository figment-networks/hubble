require_relative '../alert_subscription_factory'

FactoryBot.define do
  factory :livepeer_alert_subscription, parent: :alert_subscription do
    user { create(:user) }
    alertable { create(:livepeer_delegator_list, user: user) }

    event_kinds { %w[reward_cut_change] }
    wants_daily_digest { false }
  end
end
