class AddChainToLivepeerRebonds < ActiveRecord::Migration[5.2]
  def change
    add_reference :livepeer_rebonds, :chain
    add_foreign_key :livepeer_rebonds, :livepeer_chains, column: :chain_id
  end
end
