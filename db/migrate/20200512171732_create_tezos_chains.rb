class CreateTezosChains < ActiveRecord::Migration[5.2]
  def change
    create_table :tezos_chains do |t|
      t.string :name
      t.string :slug
      t.boolean :primary
      t.bigint :latest_event_height

      t.timestamps
    end
  end
end
