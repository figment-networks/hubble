class Livepeer < ActiveRecord::Migration[5.2]
  def change
    create_table "livepeer_chains", force: :cascade do |t|
      t.string "name"
      t.string "url"
      t.datetime "synchronized_at"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["name"], name: "index_livepeer_chains_on_name"
    end

    create_table "livepeer_bonds", force: :cascade do |t|
      t.string "transaction_hash"
      t.integer "round_number"
      t.string "delegator_address"
      t.string "transcoder_address"
      t.string "old_transcoder_address"
      t.decimal "amount"
      t.datetime "initialized_at"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["delegator_address"], name: "index_livepeer_bonds_on_delegator_address"
      t.index ["round_number"], name: "index_livepeer_bonds_on_round_number"
      t.index ["transaction_hash"], name: "index_livepeer_bonds_on_transaction_hash"
    end

    create_table "livepeer_delegator_lists", force: :cascade do |t|
      t.bigint "user_id", null: false
      t.string "name"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "addresses", default: [], array: true
      t.boolean "email_alerts_enabled", default: false
      t.index ["user_id"], name: "index_livepeer_delegator_lists_on_user_id"
    end

    create_table "livepeer_pools", force: :cascade do |t|
      t.bigint "round_id", null: false
      t.decimal "total_stake"
      t.decimal "fees"
      t.decimal "reward_tokens"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "transcoder_address"
      t.index ["round_id"], name: "index_livepeer_pools_on_round_id"
      t.index ["transcoder_address"], name: "index_livepeer_pools_on_transcoder_address"
    end

    create_table "livepeer_rebonds", force: :cascade do |t|
      t.string "transaction_hash"
      t.integer "round_number"
      t.string "delegator_address"
      t.string "transcoder_address"
      t.decimal "amount"
      t.datetime "initialized_at"
      t.integer "unbonding_lock_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["delegator_address"], name: "index_livepeer_rebonds_on_delegator_address"
      t.index ["round_number"], name: "index_livepeer_rebonds_on_round_number"
      t.index ["transaction_hash"], name: "index_livepeer_rebonds_on_transaction_hash"
    end

    create_table "livepeer_rounds", force: :cascade do |t|
      t.integer "number"
      t.datetime "initialized_at"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.decimal "mintable_tokens"
      t.index ["number"], name: "index_livepeer_rounds_on_number"
    end

    create_table "livepeer_shares", force: :cascade do |t|
      t.bigint "pool_id", null: false
      t.decimal "fees"
      t.decimal "reward_tokens"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "delegator_address"
      t.index ["delegator_address"], name: "index_livepeer_shares_on_delegator_address"
      t.index ["pool_id"], name: "index_livepeer_shares_on_pool_id"
    end

    create_table "livepeer_transcoders", force: :cascade do |t|
      t.string "address"
      t.boolean "active"
      t.decimal "reward_cut"
      t.decimal "fee_share"
      t.decimal "total_stake"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["address"], name: "index_livepeer_transcoders_on_address"
    end

    create_table "livepeer_unbonds", force: :cascade do |t|
      t.string "transaction_hash"
      t.integer "round_number"
      t.string "delegator_address"
      t.string "transcoder_address"
      t.decimal "amount"
      t.datetime "initialized_at"
      t.integer "withdraw_round_number"
      t.integer "unbonding_lock_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["delegator_address"], name: "index_livepeer_unbonds_on_delegator_address"
      t.index ["round_number"], name: "index_livepeer_unbonds_on_round_number"
      t.index ["transaction_hash"], name: "index_livepeer_unbonds_on_transaction_hash"
      t.index ["withdraw_round_number"], name: "index_livepeer_unbonds_on_withdraw_round_number"
    end

    add_foreign_key "livepeer_delegator_lists", "users"
    add_foreign_key "livepeer_pools", "livepeer_rounds", column: "round_id"
    add_foreign_key "livepeer_shares", "livepeer_pools", column: "pool_id"
  end
end
