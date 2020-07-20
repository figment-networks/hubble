class RenameUrlToSubgraphUrlInLivepeerChains < ActiveRecord::Migration[5.2]
  def change
    rename_column :livepeer_chains, :url, :subgraph_url
  end
end
