class CreateLivepeerDelegators < ActiveRecord::Migration[5.2]
  def change
    create_table :livepeer_delegators do |t|
      t.belongs_to :transcoder
      t.string :address

      t.timestamps
    end
    add_index :livepeer_delegators, :address
    add_foreign_key :livepeer_delegators, :livepeer_transcoders, column: :transcoder_id
  end
end
