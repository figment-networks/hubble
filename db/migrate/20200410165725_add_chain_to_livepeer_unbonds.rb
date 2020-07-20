class AddChainToLivepeerUnbonds < ActiveRecord::Migration[5.2]
  def change
    add_reference :livepeer_unbonds, :chain
    add_foreign_key :livepeer_unbonds, :livepeer_chains, column: :chain_id
  end
end
