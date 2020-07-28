class AddChainToLivepeerTranscoders < ActiveRecord::Migration[5.2]
  def change
    add_reference :livepeer_transcoders, :chain
    add_foreign_key :livepeer_transcoders, :livepeer_chains, column: :chain_id
  end
end
