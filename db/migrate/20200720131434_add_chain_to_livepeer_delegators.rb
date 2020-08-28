class AddChainToLivepeerDelegators < ActiveRecord::Migration[5.2]
  def change
    add_reference :livepeer_delegators, :chain
    add_foreign_key :livepeer_delegators, :livepeer_chains, column: :chain_id
  end
end
