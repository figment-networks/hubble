class RemoveTokenMapColumns < ActiveRecord::Migration[5.2]
  def change
    remove_column :oasis_chains, :token_map, :jsonb, default: {}
    remove_column :near_chains, :token_map, :jsonb, default: {}
    remove_column :coda_chains, :token_map, :jsonb, default: {}
  end
end
