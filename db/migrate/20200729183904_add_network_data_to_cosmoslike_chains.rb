class AddNetworkDataToCosmoslikeChains < ActiveRecord::Migration[5.2]
  def change
    add_column :cosmos_chains, :staking_participation, :float
    add_column :cosmos_chains, :rewards_rate, :float
    add_column :cosmos_chains, :daily_rewards, :float

    add_column :terra_chains, :staking_participation, :float
    add_column :terra_chains, :rewards_rate, :float
    add_column :terra_chains, :daily_rewards, :float

    add_column :emoney_chains, :staking_participation, :float
    add_column :emoney_chains, :rewards_rate, :float
    add_column :emoney_chains, :daily_rewards, :float

    add_column :kava_chains, :staking_participation, :float
    add_column :kava_chains, :rewards_rate, :float
    add_column :kava_chains, :daily_rewards, :float

    add_column :iris_chains, :staking_participation, :float
    add_column :iris_chains, :rewards_rate, :float
    add_column :iris_chains, :daily_rewards, :float
  end
end
