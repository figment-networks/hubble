class FixTezosSubscriptionCounts < ActiveRecord::Migration[5.2]
  def change
    AlertSubscription.counter_culture_fix_counts
  end
end
