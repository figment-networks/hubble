class Oasis < ActiveRecord::Migration[5.2]
  def change
  	create_table "oasis_chains", force: :cascade do |t|
      t.string "name", null: false
      t.string "api_url", null: false
      t.boolean "testnet", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.boolean "primary", default: false
      t.string "slug", null: false
      t.boolean "disabled", default: false
      t.string "token_denom", default: "Oasis"
      t.bigint "token_factor", default: 0
      t.boolean "dead", default: false
      t.integer "position"
      t.jsonb "token_map", default: {}
      t.index ["name"], name: "index_oasis_chains_on_name"
    end
  end
end
