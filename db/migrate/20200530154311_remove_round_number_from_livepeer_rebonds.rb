class RemoveRoundNumberFromLivepeerRebonds < ActiveRecord::Migration[5.2]
  def change
    remove_index :livepeer_rebonds, :round_number
    remove_column :livepeer_rebonds, :round_number, :integer
  end
end
