class AddMissingMigration < ActiveRecord::Migration[5.2]
  def change
    add_column :cosmos_chains, :network, :string
    change_column :cosmos_validators, :current_voting_power, :decimal, default: 0.0
  end
end
