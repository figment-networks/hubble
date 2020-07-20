class RemoveRoundNumberFromLivepeerUnbonds < ActiveRecord::Migration[5.2]
  def change
    remove_index :livepeer_unbonds, :round_number
    remove_column :livepeer_unbonds, :round_number, :integer
  end
end
