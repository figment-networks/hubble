class RemoveRoundNumberFromLivepeerBonds < ActiveRecord::Migration[5.2]
  def change
    remove_index :livepeer_bonds, :round_number
    remove_column :livepeer_bonds, :round_number, :integer
  end
end
