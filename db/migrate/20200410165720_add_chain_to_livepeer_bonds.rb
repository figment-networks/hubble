class AddChainToLivepeerBonds < ActiveRecord::Migration[5.2]
  def change
    add_reference :livepeer_bonds, :chain
    add_foreign_key :livepeer_bonds, :livepeer_chains, column: :chain_id
  end
end
