class RemoveChainFromLivepeerUnbonds < ActiveRecord::Migration[5.2]
  def change
    remove_reference :livepeer_unbonds, :chain
  end
end
