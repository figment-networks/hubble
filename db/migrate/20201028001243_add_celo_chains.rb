class AddCeloChains < ActiveRecord::Migration[5.2]
  def change
    create_table :celo_chains do |t|
      t.string :name, null: false
      t.string :slug, null: false, index: true
      t.string :api_url, null: false
      t.boolean :testnet, null: false
      t.boolean :primary, null: false, default: false
      t.boolean :disabled, default: true
      t.boolean :dead, default: false
      t.integer :position
      t.timestamps
    end
  end
end
