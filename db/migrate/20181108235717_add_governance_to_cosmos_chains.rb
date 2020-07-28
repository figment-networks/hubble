class AddGovernanceToCosmosChains < ActiveRecord::Migration[5.2]
  def change
    add_column :cosmos_chains, :governance, :jsonb, null: false, default: '{}'
  end
end
