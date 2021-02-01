require 'rails_helper'

describe Avalanche::Validator do
  let(:validator) { described_class.new(attributes) }
  let(:attributes) do
    {
      'node_id' => 'NodeID-GQxEp8xDqCpQnEheJVFPzkPqLkNSzEx9B',
      'stake_amount' => '2000000000000',
      'stake_percent' => 0.0009414160050830828,
      'potential_reward' => '229786251377',
      'reward_address' => 'P-avax190dvv77894l5tdfwhjz6vmj6q7c65dv3dhasr0',
      'active' => true,
      'active_start_time' => '2020-11-09T18:47:26Z',
      'active_end_time' => '2021-11-09T18:47:26Z',
      'active_progress_percent' => 16.435721695839675,
      'uptime' => 98.6299991607666,
      'delegations_count' => 6,
      'delegations_percent' => 0.19543973941368079,
      'delegated_amount' => '2257271703275',
      'delegated_amount_percent' => 0.006031391860223406,
      'delegation_fee' => 2,
      'capacity' => '5742728296725',
      'capacity_percent' => 28.2158962909375,
      'first_height' => 268321,
      'last_height' => 268321
    }
  end

  it 'Rounds the uptime correctly' do
    expect(validator.uptime).to eq 98
  end

  it 'Calculates the total stake correctly' do
    expect(validator.total_stake).to eq 4257271703275
  end
end
