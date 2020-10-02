class CreateCodaChains < ActiveRecord::Migration[5.2]
  def change
    create_table :coda_chains do |t|
      t.string  :name, null: false
      t.string  :slug, null: false, index: true
      t.string  :api_url, null: false
      t.boolean :testnet, null: false
      t.boolean :primary, null: false, default: false
      t.boolean :disabled, default: true
      t.boolean :dead, default: false
      t.text    :token_denom
      t.bigint  :token_factor, default: 0
      t.jsonb   :token_map, default: {}
      t.integer :position
      t.timestamps
    end
  end
end
