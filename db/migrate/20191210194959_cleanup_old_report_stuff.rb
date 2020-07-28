class CleanupOldReportStuff < ActiveRecord::Migration[5.2]
  def change
    drop_table :common_reward_snapshots
    remove_column :cosmos_accounts, :run_next_rewards_report
    remove_column :kava_accounts, :run_next_rewards_report
    remove_column :terra_accounts, :run_next_rewards_report
    remove_column :iris_accounts, :run_next_rewards_report
    remove_column :cosmos_blocks, :raw_block
    remove_column :cosmos_blocks, :raw_commit
  end
end
