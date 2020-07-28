class RemoveChainFromLivepeerRebonds < ActiveRecord::Migration[5.2]
  def change
    remove_reference :livepeer_rebonds, :chain
  end
end
