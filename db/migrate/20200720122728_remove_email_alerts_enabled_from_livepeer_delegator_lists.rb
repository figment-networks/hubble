class RemoveEmailAlertsEnabledFromLivepeerDelegatorLists < ActiveRecord::Migration[5.2]
  def change
    remove_column :livepeer_delegator_lists, :email_alerts_enabled, :boolean, default: false
  end
end
