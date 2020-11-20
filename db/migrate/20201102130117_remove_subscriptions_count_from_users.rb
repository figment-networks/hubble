class RemoveSubscriptionsCountFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :subscriptions_count, :integer
  end
end
