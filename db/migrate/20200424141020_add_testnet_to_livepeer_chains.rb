class AddTestnetToLivepeerChains < ActiveRecord::Migration[5.2]
  def change
    add_column :livepeer_chains, :testnet, :boolean
  end
end
