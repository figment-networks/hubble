require 'rails_helper'

describe Avalanche::Delegation do
  let(:delegation) { described_class.new(attributes) }
  let(:attributes) do
    {
      'id' => 'f227b9cf322f9556fe066532cc741e3408c5d7b5',
      'node_id' => 'NodeID-Hyr1U8Tbw1Q9wgJYRfraYsEp9EzMugRte',
      'stake_amount' => '101998704423',
      'potential_reward' => '365056493',
      'reward_address' => 'P-avax1ke9j7mskge5ku725mu3hjxfhc8f9ct9l79ddhr',
      'active' => true,
      'active_start_time' => '2021-01-07T15:17:24Z',
      'active_end_time' => '2021-01-21T15:17:24Z',
      'first_height' => 267232,
      'last_height' => 268485
    }
  end

  it 'Converts stake_amount to an int correctly' do
    expect(delegation.stake_amount).to be_a Integer
  end

  it 'Converts potential_reward to an int correctly' do
    expect(delegation.potential_reward).to be_a Integer
  end
end
