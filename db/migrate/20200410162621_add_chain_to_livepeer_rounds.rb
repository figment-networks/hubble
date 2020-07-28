class AddChainToLivepeerRounds < ActiveRecord::Migration[5.2]
  def change
    add_reference :livepeer_rounds, :chain
    add_foreign_key :livepeer_rounds, :livepeer_chains, column: :chain_id
  end
end
