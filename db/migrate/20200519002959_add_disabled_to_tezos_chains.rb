class AddDisabledToTezosChains < ActiveRecord::Migration[5.2]
  def change
    add_column :tezos_chains, :disabled, :boolean, default: true
  end
end
