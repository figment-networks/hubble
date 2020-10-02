class AddPendingStakeToLivepeerDelegators < ActiveRecord::Migration[5.2]
  def change
    add_column :livepeer_delegators, :pending_stake, :decimal
  end
end
