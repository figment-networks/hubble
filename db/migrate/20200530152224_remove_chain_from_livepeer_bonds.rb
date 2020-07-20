class RemoveChainFromLivepeerBonds < ActiveRecord::Migration[5.2]
  def change
    remove_reference :livepeer_bonds, :chain
  end
end
