class AddChainToLivepeerDelegatorLists < ActiveRecord::Migration[5.2]
  def change
    add_reference :livepeer_delegator_lists, :chain
    add_foreign_key :livepeer_delegator_lists, :livepeer_chains, column: :chain_id
  end
end
