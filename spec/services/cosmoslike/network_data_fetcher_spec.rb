require 'rails_helper'

RSpec.describe Cosmoslike::NetworkDataFetcher do

  let(:chain) do
    double('Cosmoslike::Chainlike',
           staked_amount: 670_000.0,
           average_block_time: 6.5,
           namespace: Cosmos
    )
  end

  let(:syncer) do
    double('Cosmoslike::SyncBase',
           get_total_supply: 1_000_000.0,
           get_reported_blocks_per_year: 5_000_000.0,
           get_reported_inflation: 8.0
    )
  end

  subject { described_class.new(chain, syncer) }

  it "fetches daily rewards" do
    expect(subject.daily_rewards.round(2)).to eq(0.02)
  end

  it "fetches rewards rate" do
    expect(subject.rewards_rate.round(2)).to eq(1136.2)
  end

  it "fetches staking participation" do
    expect(subject.staking_participation).to eq(67.0)
  end
end
