class AddIndexerApiBaseUrlToTezosChains < ActiveRecord::Migration[5.2]
  def change
    add_column :tezos_chains, :indexer_api_base_url, :string
  end
end
