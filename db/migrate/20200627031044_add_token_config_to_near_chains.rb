class AddTokenConfigToNearChains < ActiveRecord::Migration[5.2]
  def change
    add_column :near_chains, :token_denom, :text
    add_column :near_chains, :token_factor, :bigint, default: 0
    add_column :near_chains, :token_map, :jsonb, default: {}
  end
end
