class AddRoundToLivepeerBonds < ActiveRecord::Migration[5.2]
  def change
    add_reference :livepeer_bonds, :round
    add_foreign_key :livepeer_bonds, :livepeer_rounds, column: :round_id
  end
end
