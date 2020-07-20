class AddDefaultToCurrentUptime < ActiveRecord::Migration[5.2]
  def change
    change_column :cosmos_validators, :current_uptime, :decimal, default: 0.0
  end
end
