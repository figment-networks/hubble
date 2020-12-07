class AddTxSearchToTerraChains < ActiveRecord::Migration[5.2]
  def change
    add_column :terra_chains, :tx_search_url, :string
    add_column :terra_chains, :tx_search_enabled, :boolean, default: false
  end
end
