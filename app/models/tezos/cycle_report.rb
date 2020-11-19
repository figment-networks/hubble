class Tezos::CycleReport < ApplicationRecord
  after_create :notify_subscribed_users

  private

  def notify_subscribed_users
    User.with_subscriptions('Tezos').find_each do |user|
      TezosMailer.with(user: user, cycle_number: cycle_number).cycle_report.deliver_now
    end
  end
end
