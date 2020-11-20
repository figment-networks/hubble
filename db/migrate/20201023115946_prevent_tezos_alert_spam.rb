class PreventTezosAlertSpam < ActiveRecord::Migration[5.2]
  def change
    ids = AlertableAddress.where(chain_type: "Tezos::Chain").pluck(:id)
    subs = AlertSubscription.where(alertable_type: "AlertableAddress", alertable_id: ids)
    subs.update_all(last_instant_at: Time.now.utc, last_daily_at: 1.day.ago.end_of_day)
  end
end
