class CreateCommonRewardSnapshots < ActiveRecord::Migration[5.2]
  def change
    create_table :common_reward_snapshots do |t|
      t.references :chainlike, polymorphic: true, null: false, index: { name: 'index_rs_on_c' }
      t.references :accountlike, polymorphic: true, null: false, index: { name: 'index_rs_on_a' }

      t.string :denom, null: false
      t.decimal :balance
      t.decimal :bond
      t.decimal :pending_rewards
      t.decimal :pending_commission
      t.decimal :net_transactions
      t.boolean :exclusive

      t.datetime :approx_timestamp
      t.bigint :approx_height

      t.timestamps
    end

    add_column :cosmos_accounts, :run_next_rewards_report, :boolean, default: true
    add_column :iris_accounts, :run_next_rewards_report, :boolean, default: true
    add_column :terra_accounts, :run_next_rewards_report, :boolean, default: true
  end
end
