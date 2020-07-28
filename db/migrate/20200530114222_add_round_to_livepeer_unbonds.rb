class AddRoundToLivepeerUnbonds < ActiveRecord::Migration[5.2]
  def change
    add_reference :livepeer_unbonds, :round
    add_foreign_key :livepeer_unbonds, :livepeer_rounds, column: :round_id
  end
end
