class AddRoundToLivepeerRebonds < ActiveRecord::Migration[5.2]
  def change
    add_reference :livepeer_rebonds, :round
    add_foreign_key :livepeer_rebonds, :livepeer_rounds, column: :round_id
  end
end
