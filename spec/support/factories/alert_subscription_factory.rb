FactoryBot.define do
  factory :alert_subscription do
    user { create(:user) }
    alertable { create(:cosmos_validator) }

    event_kinds { %w[voting_power_change n_of_m] }
    data { { 'percent_change' => 15.0 } }
    wants_daily_digest { true }
    last_daily_at { 1.day.ago.end_of_day }
    last_instant_at { Time.now.utc }
  end
end
