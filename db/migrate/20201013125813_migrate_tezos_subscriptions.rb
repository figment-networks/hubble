class MigrateTezosSubscriptions < ActiveRecord::Migration[5.2]
  def up
    chain = Tezos::Chain.primary

    Subscription.find_each do |sub|
      alertable_address = AlertableAddress.find_or_create_by(
        chain: chain,
        address: sub.baker_id
      )

      alert_subscription = AlertSubscription.create(
        user: sub.user,
        alertable: alertable_address,
        last_instant_at: Time.current,
        last_daily_at: 1.day.ago.end_of_day,
        event_kinds: chain.event_kinds
      )

      sub.destroy
    end
  end

  def down

  end
end
