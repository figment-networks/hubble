class AddEmoney < ActiveRecord::Migration[5.2]
  def change
    create_table "emoney_accounts", force: :cascade do |t|
      t.string "address"
      t.bigint "chain_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.bigint "validator_id"
      t.index ["address"], name: "index_emoney_accounts_on_address"
      t.index ["chain_id"], name: "index_emoney_account_on_chain"
    end

    create_table "emoney_blocks", force: :cascade do |t|
      t.bigint "chain_id"
      t.string "id_hash", null: false
      t.bigint "height", null: false
      t.datetime "timestamp", null: false
      t.string "precommitters", default: [], array: true
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.jsonb "validator_set", default: {}
      t.string "proposer_address"
      t.string "transactions", array: true
      t.index ["chain_id", "height", "timestamp"], name: "index_emoney_b_on_c__h__t"
      t.index ["chain_id", "height"], name: "index_emoney_b_on_c__h", unique: true
      t.index ["chain_id", "id_hash"], name: "index_emoney_b_on_hash", unique: true
      t.index ["precommitters"], name: "index_emoney_b_on_pc", using: :gin
    end

    create_table "emoney_chains", force: :cascade do |t|
      t.string "name", null: false
      t.boolean "testnet", null: false
      t.bigint "history_height", default: 0
      t.datetime "last_sync_time"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.boolean "primary", default: false
      t.string "slug", null: false
      t.string "rpc_host"
      t.integer "rpc_port"
      t.integer "lcd_port"
      t.boolean "disabled", default: false
      t.jsonb "validator_event_defs", default: [{"kind"=>"voting_power_change", "height"=>0}, {"kind"=>"active_set_inclusion", "height"=>0}]
      t.integer "failed_sync_count", default: 0
      t.jsonb "governance", default: {}, null: false
      t.string "ext_id"
      t.datetime "halted_at"
      t.string "last_round_state", default: ""
      t.string "token_denom", default: "atom"
      t.bigint "token_factor", default: 0
      t.string "sdk_version"
      t.text "notes"
      t.string "network"
      t.boolean "use_ssl_for_lcd", default: false
      t.jsonb "staking_pool", default: {}
      t.string "remote_denom"
      t.boolean "dead", default: false
      t.integer "position"
      t.integer "latest_local_height", default: 0
      t.datetime "cutoff_at"
      t.jsonb "token_map", default: {}
      t.jsonb "twitter_events_config", default: {}
      t.json "community_pool"
      t.string "lcd_host"
      t.string "rpc_path"
      t.string "lcd_path"
      t.boolean "use_ssl_for_rpc", default: false
    end

    create_table "emoney_faucets", force: :cascade do |t|
      t.bigint "chain_id"
      t.boolean "disabled", default: false
      t.string "address", null: false
      t.string "encrypted_private_key", null: false
      t.string "encrypted_private_key_iv", null: false
      t.string "disbursement_amount"
      t.string "fee_amount"
      t.string "denom"
      t.string "current_sequence"
      t.index ["chain_id"], name: "index_emoney_faucets_on_chain_id"
    end

    create_table "emoney_governance_deposits", force: :cascade do |t|
      t.bigint "account_id"
      t.bigint "proposal_id"
      t.string "amount_denom"
      t.bigint "amount"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["account_id"], name: "index_emoney_deposit_on_account"
      t.index ["proposal_id"], name: "index_emoney_deposit_on_proposal"
    end

    create_table "emoney_governance_proposals", force: :cascade do |t|
      t.bigint "chain_id"
      t.bigint "ext_id"
      t.string "title"
      t.text "description"
      t.string "proposal_type"
      t.string "proposal_status"
      t.decimal "tally_result_yes"
      t.decimal "tally_result_abstain"
      t.decimal "tally_result_no"
      t.decimal "tally_result_nowithveto"
      t.datetime "submit_time"
      t.jsonb "total_deposit", default: {}
      t.datetime "voting_start_time"
      t.datetime "voting_end_time"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.datetime "deposit_end_time"
      t.json "additional_data"
      t.boolean "finalized", default: false
      t.index ["chain_id", "ext_id"], name: "index_emoney_governance_proposals_on_chain_and_cp_id", unique: true
      t.index ["chain_id"], name: "index_emoney_proposal_on_chain"
      t.index ["ext_id"], name: "index_emoney_governance_proposals_on_ext_id"
      t.index ["proposal_status"], name: "index_emoney_governance_proposals_on_proposal_status"
      t.index ["proposal_type"], name: "index_emoney_governance_proposals_on_proposal_type"
      t.index ["submit_time"], name: "index_emoney_governance_proposals_on_submit_time"
      t.index ["voting_end_time"], name: "index_emoney_governance_proposals_on_voting_end_time"
      t.index ["voting_start_time"], name: "index_emoney_governance_proposals_on_voting_start_time"
    end

    create_table "emoney_governance_votes", force: :cascade do |t|
      t.bigint "account_id"
      t.bigint "proposal_id"
      t.string "option"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["account_id"], name: "index_emoney_vote_on_account"
      t.index ["proposal_id"], name: "index_emoney_vote_on_proposal"
    end

    create_table "emoney_validators", force: :cascade do |t|
      t.bigint "chain_id"
      t.string "address", null: false
      t.decimal "current_voting_power", default: "0.0"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.bigint "latest_block_height"
      t.jsonb "info", default: {}
      t.datetime "first_seen_at"
      t.bigint "total_precommits", default: 0
      t.decimal "current_uptime", default: "0.0"
      t.bigint "total_proposals", default: 0
      t.datetime "last_updated"
      t.string "owner"
      t.string "moniker"
      t.index ["address"], name: "index_emoney_v_on_addr"
      t.index ["chain_id", "address"], name: "index_emoney_v_on_c__addr", unique: true
      t.index ["chain_id"], name: "index_emoney_v_on_c"
    end

    add_foreign_key "emoney_blocks", "emoney_chains", column: "chain_id"
    add_foreign_key "emoney_validators", "emoney_chains", column: "chain_id"
  end
end
