class CreateLivepeerEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :livepeer_events do |t|
      t.belongs_to :round
      t.string :type
      t.datetime :timestamp
      t.string :transcoder_address
      t.jsonb :data, default: {}

      t.timestamps
    end
    add_index :livepeer_events, :type
    add_index :livepeer_events, :transcoder_address
    add_foreign_key :livepeer_events, :livepeer_rounds, column: :round_id
  end
end
