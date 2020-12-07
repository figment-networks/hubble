# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_11_02_182344) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "btree_gin"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "administrators", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "otp_secret_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "one_time_setup_token"
  end

  create_table "alert_subscriptions", force: :cascade do |t|
    t.string "alertable_type", null: false
    t.bigint "alertable_id", null: false
    t.bigint "user_id", null: false
    t.string "event_kinds", default: [], array: true
    t.boolean "wants_daily_digest", default: false
    t.datetime "last_instant_at"
    t.datetime "last_daily_at"
    t.jsonb "data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "instant_count", default: 0
    t.integer "daily_count", default: 0
    t.string "network"
    t.index ["alertable_type", "alertable_id"], name: "index_alert_subscriptions_on_alertable_type_and_alertable_id"
    t.index ["user_id", "alertable_type", "alertable_id"], name: "index_alerts_u_a"
    t.index ["user_id"], name: "index_alert_subscriptions_on_user_id"
  end

  create_table "alertable_addresses", force: :cascade do |t|
    t.string "chain_type"
    t.bigint "chain_id"
    t.string "address"
    t.index ["chain_type", "chain_id"], name: "index_alertable_addresses_on_chain_type_and_chain_id"
  end

  create_table "avalanche_chains", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "api_url", null: false
    t.boolean "testnet", null: false
    t.boolean "primary", default: false, null: false
    t.boolean "disabled", default: true
    t.boolean "dead", default: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_avalanche_chains_on_slug"
  end

  create_table "celo_chains", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "api_url", null: false
    t.boolean "testnet", null: false
    t.boolean "primary", default: false, null: false
    t.boolean "disabled", default: true
    t.boolean "dead", default: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_celo_chains_on_slug"
  end

  create_table "coda_chains", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "api_url", null: false
    t.boolean "testnet", null: false
    t.boolean "primary", default: false, null: false
    t.boolean "disabled", default: true
    t.boolean "dead", default: false
    t.text "token_denom"
    t.bigint "token_factor", default: 0
    t.jsonb "token_map", default: {}
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_coda_chains_on_slug"
  end

  create_table "common_validator_event_latches", force: :cascade do |t|
    t.bigint "chainlike_id"
    t.bigint "validatorlike_id"
    t.string "event_definition_id"
    t.binary "state"
    t.boolean "held", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "chainlike_type"
    t.string "validatorlike_type"
    t.index ["chainlike_id", "validatorlike_id", "event_definition_id"], name: "index_cosmos_vel_all"
    t.index ["chainlike_id"], name: "index_common_validator_event_latches_on_chainlike_id"
    t.index ["validatorlike_id"], name: "index_common_validator_event_latches_on_validatorlike_id"
  end

  create_table "common_validator_events", force: :cascade do |t|
    t.string "type"
    t.datetime "timestamp"
    t.bigint "height"
    t.bigint "chainlike_id"
    t.bigint "validatorlike_id"
    t.jsonb "data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "event_definition_id"
    t.string "chainlike_type"
    t.string "validatorlike_type"
    t.index ["chainlike_id"], name: "index_common_validator_events_on_chainlike_id"
    t.index ["type"], name: "index_common_validator_events_on_type"
    t.index ["validatorlike_id"], name: "index_common_validator_events_on_validatorlike_id"
  end

  create_table "common_watches", force: :cascade do |t|
    t.bigint "chainlike_id"
    t.string "watchable_type", null: false
    t.bigint "watchable_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "chainlike_type"
    t.index ["chainlike_id"], name: "index_common_watches_on_chainlike_id"
    t.index ["user_id"], name: "index_common_watches_on_user_id"
    t.index ["watchable_type", "watchable_id"], name: "index_common_watches_on_watchable_type_and_watchable_id"
  end

  create_table "cosmos_accounts", force: :cascade do |t|
    t.string "address"
    t.bigint "chain_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "validator_id"
    t.index ["address"], name: "index_cosmos_accounts_on_address"
    t.index ["chain_id"], name: "index_cosmos_account_on_chain"
  end

  create_table "cosmos_blocks", force: :cascade do |t|
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
    t.index ["chain_id", "height", "timestamp"], name: "index_cosmos_b_on_c__h__t"
    t.index ["chain_id", "height"], name: "index_cosmos_b_on_c__h", unique: true
    t.index ["chain_id", "id_hash"], name: "index_cosmos_b_on_hash", unique: true
    t.index ["precommitters"], name: "index_cosmos_b_on_pc", using: :gin
  end

  create_table "cosmos_chains", force: :cascade do |t|
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
    t.datetime "halted_at"
    t.string "last_round_state", default: ""
    t.string "ext_id"
    t.string "token_denom", default: "atom"
    t.bigint "token_factor", default: 0
    t.string "sdk_version"
    t.text "notes"
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
    t.string "network"
    t.float "staking_participation"
    t.float "rewards_rate"
    t.float "daily_rewards"
  end

  create_table "cosmos_faucets", force: :cascade do |t|
    t.bigint "chain_id"
    t.boolean "disabled", default: false
    t.string "address", null: false
    t.string "encrypted_private_key", null: false
    t.string "encrypted_private_key_iv", null: false
    t.string "disbursement_amount"
    t.string "fee_amount"
    t.string "denom"
    t.string "current_sequence"
    t.index ["chain_id"], name: "index_cosmos_faucets_on_chain_id"
  end

  create_table "cosmos_governance_deposits", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "proposal_id"
    t.string "amount_denom"
    t.bigint "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_cosmos_deposit_on_account"
    t.index ["proposal_id"], name: "index_cosmos_deposit_on_proposal"
  end

  create_table "cosmos_governance_proposals", force: :cascade do |t|
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
    t.index ["chain_id", "ext_id"], name: "index_cosmos_governance_proposals_on_chain_and_cp_id", unique: true
    t.index ["chain_id"], name: "index_cosmos_proposal_on_chain"
    t.index ["ext_id"], name: "index_cosmos_governance_proposals_on_ext_id"
    t.index ["proposal_status"], name: "index_cosmos_governance_proposals_on_proposal_status"
    t.index ["proposal_type"], name: "index_cosmos_governance_proposals_on_proposal_type"
    t.index ["submit_time"], name: "index_cosmos_governance_proposals_on_submit_time"
    t.index ["voting_end_time"], name: "index_cosmos_governance_proposals_on_voting_end_time"
    t.index ["voting_start_time"], name: "index_cosmos_governance_proposals_on_voting_start_time"
  end

  create_table "cosmos_governance_votes", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "proposal_id"
    t.string "option"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_cosmos_vote_on_account"
    t.index ["proposal_id"], name: "index_cosmos_vote_on_proposal"
  end

  create_table "cosmos_validators", force: :cascade do |t|
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
    t.index ["address"], name: "index_cosmos_v_on_addr"
    t.index ["chain_id", "address"], name: "index_cosmos_v_on_c__addr", unique: true
    t.index ["chain_id"], name: "index_cosmos_v_on_c"
  end

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
    t.float "staking_participation"
    t.float "rewards_rate"
    t.float "daily_rewards"
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

  create_table "iris_accounts", force: :cascade do |t|
    t.string "address"
    t.bigint "chain_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "validator_id"
    t.index ["address"], name: "index_iris_accounts_on_address"
    t.index ["chain_id"], name: "index_iris_account_on_chain"
  end

  create_table "iris_blocks", force: :cascade do |t|
    t.bigint "chain_id"
    t.string "id_hash", null: false
    t.bigint "height", null: false
    t.datetime "timestamp", null: false
    t.string "precommitters", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "raw_block"
    t.text "raw_commit"
    t.jsonb "validator_set", default: {}
    t.string "proposer_address"
    t.string "transactions", array: true
    t.index ["chain_id", "height", "timestamp"], name: "index_iris_b_on_c__h__t"
    t.index ["chain_id", "height"], name: "index_iris_b_on_c__h", unique: true
    t.index ["chain_id", "id_hash"], name: "index_iris_b_on_hash", unique: true
    t.index ["precommitters"], name: "index_iris_b_on_pc", using: :gin
  end

  create_table "iris_chains", force: :cascade do |t|
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
    t.datetime "halted_at"
    t.string "last_round_state", default: ""
    t.string "ext_id"
    t.string "token_denom", default: "atom"
    t.bigint "token_factor", default: 0
    t.string "sdk_version"
    t.text "notes"
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
    t.float "staking_participation"
    t.float "rewards_rate"
    t.float "daily_rewards"
  end

  create_table "iris_faucets", force: :cascade do |t|
    t.bigint "chain_id"
    t.boolean "disabled", default: false
    t.string "address", null: false
    t.string "encrypted_private_key", null: false
    t.string "encrypted_private_key_iv", null: false
    t.string "disbursement_amount"
    t.string "fee_amount"
    t.string "denom"
    t.string "current_sequence"
    t.index ["chain_id"], name: "index_iris_faucets_on_chain_id"
  end

  create_table "iris_governance_deposits", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "proposal_id"
    t.string "amount_denom"
    t.bigint "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_iris_deposit_on_account"
    t.index ["proposal_id"], name: "index_iris_deposit_on_proposal"
  end

  create_table "iris_governance_proposals", force: :cascade do |t|
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
    t.index ["chain_id", "ext_id"], name: "index_iris_governance_proposals_on_chain_and_cp_id", unique: true
    t.index ["chain_id"], name: "index_iris_proposal_on_chain"
    t.index ["ext_id"], name: "index_iris_governance_proposals_on_ext_id"
    t.index ["proposal_status"], name: "index_iris_governance_proposals_on_proposal_status"
    t.index ["proposal_type"], name: "index_iris_governance_proposals_on_proposal_type"
    t.index ["submit_time"], name: "index_iris_governance_proposals_on_submit_time"
    t.index ["voting_end_time"], name: "index_iris_governance_proposals_on_voting_end_time"
    t.index ["voting_start_time"], name: "index_iris_governance_proposals_on_voting_start_time"
  end

  create_table "iris_governance_votes", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "proposal_id"
    t.string "option"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_iris_vote_on_account"
    t.index ["proposal_id"], name: "index_iris_vote_on_proposal"
  end

  create_table "iris_validators", force: :cascade do |t|
    t.bigint "chain_id"
    t.string "address", null: false
    t.bigint "current_voting_power", default: 0
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
    t.index ["address"], name: "index_iris_v_on_addr"
    t.index ["chain_id", "address"], name: "index_iris_v_on_c__addr", unique: true
    t.index ["chain_id"], name: "index_iris_v_on_c"
  end

  create_table "kava_accounts", force: :cascade do |t|
    t.string "address"
    t.bigint "chain_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "validator_id"
    t.index ["address"], name: "index_kava_accounts_on_address"
    t.index ["chain_id"], name: "index_kava_account_on_chain"
  end

  create_table "kava_blocks", force: :cascade do |t|
    t.bigint "chain_id"
    t.string "id_hash", null: false
    t.bigint "height", null: false
    t.datetime "timestamp", null: false
    t.string "precommitters", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "raw_block"
    t.text "raw_commit"
    t.jsonb "validator_set", default: {}
    t.string "proposer_address"
    t.string "transactions", array: true
    t.index ["chain_id", "height", "timestamp"], name: "index_kava_b_on_c__h__t"
    t.index ["chain_id", "height"], name: "index_kava_b_on_c__h", unique: true
    t.index ["chain_id", "id_hash"], name: "index_kava_b_on_hash", unique: true
    t.index ["precommitters"], name: "index_kava_b_on_pc", using: :gin
  end

  create_table "kava_chains", force: :cascade do |t|
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
    t.float "staking_participation"
    t.float "rewards_rate"
    t.float "daily_rewards"
  end

  create_table "kava_faucets", force: :cascade do |t|
    t.bigint "chain_id"
    t.boolean "disabled", default: false
    t.string "address", null: false
    t.string "encrypted_private_key", null: false
    t.string "encrypted_private_key_iv", null: false
    t.string "disbursement_amount"
    t.string "fee_amount"
    t.string "denom"
    t.string "current_sequence"
    t.index ["chain_id"], name: "index_kava_faucets_on_chain_id"
  end

  create_table "kava_governance_deposits", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "proposal_id"
    t.string "amount_denom"
    t.bigint "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_kava_deposit_on_account"
    t.index ["proposal_id"], name: "index_kava_deposit_on_proposal"
  end

  create_table "kava_governance_proposals", force: :cascade do |t|
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
    t.index ["chain_id", "ext_id"], name: "index_kava_governance_proposals_on_chain_and_cp_id", unique: true
    t.index ["chain_id"], name: "index_kava_proposal_on_chain"
    t.index ["ext_id"], name: "index_kava_governance_proposals_on_ext_id"
    t.index ["proposal_status"], name: "index_kava_governance_proposals_on_proposal_status"
    t.index ["proposal_type"], name: "index_kava_governance_proposals_on_proposal_type"
    t.index ["submit_time"], name: "index_kava_governance_proposals_on_submit_time"
    t.index ["voting_end_time"], name: "index_kava_governance_proposals_on_voting_end_time"
    t.index ["voting_start_time"], name: "index_kava_governance_proposals_on_voting_start_time"
  end

  create_table "kava_governance_votes", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "proposal_id"
    t.string "option"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_kava_vote_on_account"
    t.index ["proposal_id"], name: "index_kava_vote_on_proposal"
  end

  create_table "kava_validators", force: :cascade do |t|
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
    t.index ["address"], name: "index_kava_v_on_addr"
    t.index ["chain_id", "address"], name: "index_kava_v_on_c__addr", unique: true
    t.index ["chain_id"], name: "index_kava_v_on_c"
  end

  create_table "livepeer_bonds", force: :cascade do |t|
    t.string "transaction_hash"
    t.string "delegator_address"
    t.string "orchestrator_address"
    t.string "old_orchestrator_address"
    t.decimal "amount"
    t.datetime "initialized_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "round_id"
    t.index ["delegator_address"], name: "index_livepeer_bonds_on_delegator_address"
    t.index ["round_id"], name: "index_livepeer_bonds_on_round_id"
    t.index ["transaction_hash"], name: "index_livepeer_bonds_on_transaction_hash"
  end

  create_table "livepeer_chains", force: :cascade do |t|
    t.string "name"
    t.string "subgraph_url"
    t.datetime "last_sync_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.boolean "disabled", default: false
    t.boolean "testnet"
    t.text "notes"
    t.boolean "primary", default: false
    t.integer "position"
    t.integer "latest_local_height", default: 0
    t.index ["name"], name: "index_livepeer_chains_on_name"
    t.index ["slug"], name: "index_livepeer_chains_on_slug"
  end

  create_table "livepeer_delegator_lists", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "addresses", default: [], array: true
    t.bigint "chain_id"
    t.index ["chain_id"], name: "index_livepeer_delegator_lists_on_chain_id"
    t.index ["user_id"], name: "index_livepeer_delegator_lists_on_user_id"
  end

  create_table "livepeer_delegators", force: :cascade do |t|
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "chain_id"
    t.string "orchestrator_address"
    t.decimal "pending_stake"
    t.index ["address"], name: "index_livepeer_delegators_on_address"
    t.index ["chain_id"], name: "index_livepeer_delegators_on_chain_id"
    t.index ["orchestrator_address"], name: "index_livepeer_delegators_on_orchestrator_address"
  end

  create_table "livepeer_events", force: :cascade do |t|
    t.bigint "round_id"
    t.string "type"
    t.datetime "timestamp"
    t.string "orchestrator_address"
    t.jsonb "data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "transaction_hash"
    t.index ["orchestrator_address"], name: "index_livepeer_events_on_orchestrator_address"
    t.index ["round_id"], name: "index_livepeer_events_on_round_id"
    t.index ["transaction_hash"], name: "index_livepeer_events_on_transaction_hash"
    t.index ["type"], name: "index_livepeer_events_on_type"
  end

  create_table "livepeer_orchestrators", force: :cascade do |t|
    t.string "address"
    t.boolean "active"
    t.decimal "reward_cut"
    t.decimal "fee_share"
    t.decimal "total_stake"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "chain_id"
    t.string "name"
    t.string "description"
    t.string "website_url"
    t.index ["address"], name: "index_livepeer_orchestrators_on_address"
    t.index ["chain_id"], name: "index_livepeer_orchestrators_on_chain_id"
  end

  create_table "livepeer_pools", force: :cascade do |t|
    t.bigint "round_id", null: false
    t.decimal "total_stake"
    t.decimal "fees"
    t.decimal "reward_tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "orchestrator_address"
    t.index ["orchestrator_address"], name: "index_livepeer_pools_on_orchestrator_address"
    t.index ["round_id"], name: "index_livepeer_pools_on_round_id"
  end

  create_table "livepeer_rebonds", force: :cascade do |t|
    t.string "transaction_hash"
    t.string "delegator_address"
    t.string "orchestrator_address"
    t.decimal "amount"
    t.datetime "initialized_at"
    t.integer "unbonding_lock_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "round_id"
    t.index ["delegator_address"], name: "index_livepeer_rebonds_on_delegator_address"
    t.index ["round_id"], name: "index_livepeer_rebonds_on_round_id"
    t.index ["transaction_hash"], name: "index_livepeer_rebonds_on_transaction_hash"
  end

  create_table "livepeer_rounds", force: :cascade do |t|
    t.integer "number"
    t.datetime "initialized_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "mintable_tokens"
    t.bigint "chain_id"
    t.index ["chain_id"], name: "index_livepeer_rounds_on_chain_id"
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

  create_table "livepeer_stakes", force: :cascade do |t|
    t.bigint "round_id"
    t.string "delegator_address"
    t.decimal "pending_stake"
    t.decimal "unclaimed_stake"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["delegator_address"], name: "index_livepeer_stakes_on_delegator_address"
    t.index ["round_id"], name: "index_livepeer_stakes_on_round_id"
  end

  create_table "livepeer_unbonds", force: :cascade do |t|
    t.string "transaction_hash"
    t.string "delegator_address"
    t.string "orchestrator_address"
    t.decimal "amount"
    t.datetime "initialized_at"
    t.integer "withdraw_round_number"
    t.integer "unbonding_lock_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "round_id"
    t.index ["delegator_address"], name: "index_livepeer_unbonds_on_delegator_address"
    t.index ["round_id"], name: "index_livepeer_unbonds_on_round_id"
    t.index ["transaction_hash"], name: "index_livepeer_unbonds_on_transaction_hash"
    t.index ["withdraw_round_number"], name: "index_livepeer_unbonds_on_withdraw_round_number"
  end

  create_table "near_chains", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "api_url", null: false
    t.boolean "testnet", null: false
    t.boolean "primary", default: false, null: false
    t.boolean "disabled", default: true
    t.boolean "dead", default: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "token_denom"
    t.bigint "token_factor", default: 0
    t.jsonb "token_map", default: {}
    t.index ["slug"], name: "index_near_chains_on_slug"
  end

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
    t.jsonb "validator_event_defs", default: [{"kind"=>"voting_power_change", "height"=>0}, {"kind"=>"active_set_inclusion", "height"=>0}, {"kind"=>"reward_cut_change", "height"=>0}, {"kind"=>"slash", "height"=>0}]
    t.index ["name"], name: "index_oasis_chains_on_name"
  end

  create_table "polkadot_chains", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "api_url", null: false
    t.boolean "testnet", null: false
    t.boolean "primary", default: false, null: false
    t.boolean "disabled", default: true
    t.boolean "dead", default: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_polkadot_chains_on_slug"
  end

  create_table "stats_average_snapshots", force: :cascade do |t|
    t.datetime "timestamp", null: false
    t.string "interval", null: false
    t.decimal "sum", null: false
    t.decimal "count", null: false
    t.string "kind", null: false
    t.string "scopeable_type"
    t.bigint "scopeable_id"
    t.bigint "chainlike_id"
    t.string "chainlike_type"
    t.index ["chainlike_id", "interval", "kind", "scopeable_id", "scopeable_type"], name: "index_avg_c__i__k__s"
    t.index ["chainlike_id", "interval", "kind"], name: "index_avg_c__i__k"
    t.index ["timestamp"], name: "index_stats_average_snapshots_on_timestamp"
  end

  create_table "stats_daily_sync_logs", force: :cascade do |t|
    t.bigint "chainlike_id"
    t.datetime "date"
    t.integer "sync_count"
    t.decimal "total_sync_time"
    t.integer "fail_count"
    t.bigint "start_height"
    t.bigint "end_height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "chainlike_type"
    t.index ["chainlike_id"], name: "index_daily_sync_chain"
  end

  create_table "stats_faucet_transactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "faucetlike_id"
    t.bigint "user_id"
    t.string "ip", null: false
    t.string "address", null: false
    t.datetime "created_at", null: false
    t.datetime "completed_at"
    t.jsonb "result_data"
    t.string "txhash"
    t.boolean "error"
    t.string "faucetlike_type"
    t.index ["faucetlike_id"], name: "index_stats_faucet_transactions_on_faucetlike_id"
    t.index ["user_id", "ip", "address"], name: "index_stats_faucet_transactions_on_user_id_and_ip_and_address"
    t.index ["user_id"], name: "index_stats_faucet_transactions_on_user_id"
  end

  create_table "stats_sync_logs", force: :cascade do |t|
    t.bigint "chainlike_id"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.bigint "start_height"
    t.bigint "end_height"
    t.datetime "failed_at"
    t.text "error"
    t.string "current_status"
    t.string "chainlike_type"
    t.index ["chainlike_id"], name: "index_stats_sync_logs_on_chainlike_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "user_id"
    t.string "baker_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "telegram_accounts", force: :cascade do |t|
    t.string "username"
    t.string "chat_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_telegram_accounts_on_user_id", unique: true
    t.index ["username"], name: "index_telegram_accounts_on_username"
  end

  create_table "terra_accounts", force: :cascade do |t|
    t.string "address"
    t.bigint "chain_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "validator_id"
    t.index ["address"], name: "index_terra_accounts_on_address"
    t.index ["chain_id"], name: "index_terra_account_on_chain"
  end

  create_table "terra_blocks", force: :cascade do |t|
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
    t.index ["chain_id", "height", "timestamp"], name: "index_terra_b_on_c__h__t"
    t.index ["chain_id", "height"], name: "index_terra_b_on_c__h", unique: true
    t.index ["chain_id", "id_hash"], name: "index_terra_b_on_hash", unique: true
    t.index ["precommitters"], name: "index_terra_b_on_pc", using: :gin
  end

  create_table "terra_chains", force: :cascade do |t|
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
    t.datetime "halted_at"
    t.string "last_round_state", default: ""
    t.string "ext_id"
    t.string "token_denom", default: "Luna"
    t.bigint "token_factor", default: 0
    t.string "sdk_version"
    t.text "notes"
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
    t.float "staking_participation"
    t.float "rewards_rate"
    t.float "daily_rewards"
    t.string "tx_search_url"
    t.boolean "tx_search_enabled", default: false
  end

  create_table "terra_faucets", force: :cascade do |t|
    t.bigint "chain_id"
    t.boolean "disabled", default: false
    t.string "address", null: false
    t.string "encrypted_private_key", null: false
    t.string "encrypted_private_key_iv", null: false
    t.string "disbursement_amount"
    t.string "fee_amount"
    t.string "denom"
    t.string "current_sequence"
    t.index ["chain_id"], name: "index_terra_faucets_on_chain_id"
  end

  create_table "terra_governance_deposits", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "proposal_id"
    t.string "amount_denom"
    t.bigint "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_terra_deposit_on_account"
    t.index ["proposal_id"], name: "index_terra_deposit_on_proposal"
  end

  create_table "terra_governance_proposals", force: :cascade do |t|
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
    t.index ["chain_id", "ext_id"], name: "index_terra_governance_proposals_on_chain_and_cp_id", unique: true
    t.index ["chain_id"], name: "index_terra_proposal_on_chain"
    t.index ["ext_id"], name: "index_terra_governance_proposals_on_ext_id"
    t.index ["proposal_status"], name: "index_terra_governance_proposals_on_proposal_status"
    t.index ["proposal_type"], name: "index_terra_governance_proposals_on_proposal_type"
    t.index ["submit_time"], name: "index_terra_governance_proposals_on_submit_time"
    t.index ["voting_end_time"], name: "index_terra_governance_proposals_on_voting_end_time"
    t.index ["voting_start_time"], name: "index_terra_governance_proposals_on_voting_start_time"
  end

  create_table "terra_governance_votes", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "proposal_id"
    t.string "option"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_terra_vote_on_account"
    t.index ["proposal_id"], name: "index_terra_vote_on_proposal"
  end

  create_table "terra_validators", force: :cascade do |t|
    t.bigint "chain_id"
    t.string "address", null: false
    t.bigint "current_voting_power", default: 0
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
    t.index ["address"], name: "index_terra_v_on_addr"
    t.index ["chain_id", "address"], name: "index_terra_v_on_c__addr", unique: true
    t.index ["chain_id"], name: "index_terra_v_on_c"
  end

  create_table "tezos_chains", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.boolean "primary"
    t.bigint "latest_event_height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "indexer_api_base_url"
    t.boolean "disabled", default: true
  end

  create_table "tezos_cycle_reports", force: :cascade do |t|
    t.integer "cycle_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "password_reset_token"
    t.boolean "deleted", default: false
    t.datetime "last_login_at"
    t.datetime "last_seen_at"
    t.string "ip_addresses", array: true
    t.string "user_agents", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "verification_token"
    t.integer "tezos_subscriptions_count", default: 0, null: false
  end

  add_foreign_key "cosmos_blocks", "cosmos_chains", column: "chain_id"
  add_foreign_key "cosmos_validators", "cosmos_chains", column: "chain_id"
  add_foreign_key "emoney_blocks", "emoney_chains", column: "chain_id"
  add_foreign_key "emoney_validators", "emoney_chains", column: "chain_id"
  add_foreign_key "livepeer_bonds", "livepeer_rounds", column: "round_id"
  add_foreign_key "livepeer_delegator_lists", "livepeer_chains", column: "chain_id"
  add_foreign_key "livepeer_delegator_lists", "users"
  add_foreign_key "livepeer_delegators", "livepeer_chains", column: "chain_id"
  add_foreign_key "livepeer_events", "livepeer_rounds", column: "round_id"
  add_foreign_key "livepeer_orchestrators", "livepeer_chains", column: "chain_id"
  add_foreign_key "livepeer_pools", "livepeer_rounds", column: "round_id"
  add_foreign_key "livepeer_rebonds", "livepeer_rounds", column: "round_id"
  add_foreign_key "livepeer_rounds", "livepeer_chains", column: "chain_id"
  add_foreign_key "livepeer_shares", "livepeer_pools", column: "pool_id"
  add_foreign_key "livepeer_stakes", "livepeer_rounds", column: "round_id"
  add_foreign_key "livepeer_unbonds", "livepeer_rounds", column: "round_id"
  add_foreign_key "subscriptions", "users", on_delete: :cascade
  add_foreign_key "telegram_accounts", "users"
  add_foreign_key "terra_blocks", "terra_chains", column: "chain_id"
  add_foreign_key "terra_validators", "terra_chains", column: "chain_id"
end
