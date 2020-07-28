class CreateLivepeerStakes < ActiveRecord::Migration[5.2]
  def change
    create_table :livepeer_stakes do |t|
      t.belongs_to :round
      t.string :delegator_address
      t.decimal :pending_stake
      t.decimal :unclaimed_stake

      t.timestamps
    end
    add_index :livepeer_stakes, :delegator_address
    add_foreign_key :livepeer_stakes, :livepeer_rounds, column: :round_id
  end
end
