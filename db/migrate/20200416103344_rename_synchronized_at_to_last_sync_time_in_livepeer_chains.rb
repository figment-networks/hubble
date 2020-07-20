class RenameSynchronizedAtToLastSyncTimeInLivepeerChains < ActiveRecord::Migration[5.2]
  def change
    rename_column :livepeer_chains, :synchronized_at, :last_sync_time
  end
end
