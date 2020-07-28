class AddSubscriptionsCountToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :subscriptions_count, :integer, default: 0

    User.reset_column_information
    User.find_each do |user|
      User.update_counters user.id, subscriptions_count: user.subscriptions.count
    end
  end
end
