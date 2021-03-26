class CreatePrimeNetworksChainsAndAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :prime_networks do |t|
      t.string :name, null: false
      t.string :validator_title, default: 'validator'
      t.string :deligator_title, default: 'delegator'
      t.jsonb :network_info, defalut: {}
      t.timestamps
    end

    create_table :prime_chains do |t|
      t.references :prime_network
      t.string :type, null: false
      t.string :name, null: false
      t.string :slug, null: false
      t.string :api_url, null: false
      t.boolean :primary, default: false
      t.boolean :active, default: false
      t.boolean :dead, default: false
      t.string :figment_validator_addresses, array: true
      t.string :reward_token_remote, null: false
      t.string :reward_token_display, null: false
      t.integer :reward_token_factor, null: false
      t.datetime :genesis_block_time
      t.integer :genesis_block_height
      t.datetime :final_block_time
      t.integer :final_block_height
      t.timestamps
    end

    create_table :prime_accounts do |t|
      t.references :prime_network
      t.references :user
      t.string :type, null: false
      t.string :address, null: false
      t.timestamps
    end

    add_index :prime_networks, :name
    add_index :prime_chains, :name
    add_index :prime_accounts, :address

  end
end
