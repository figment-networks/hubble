class AddNetworkToAlertSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :alert_subscriptions, :network, :string
  end
end
