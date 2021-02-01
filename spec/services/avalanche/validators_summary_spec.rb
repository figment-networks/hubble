require 'rails_helper'

describe Avalanche::ValidatorDetails do
  let(:validators_summary) { described_class.new(attributes) }
  let(:attributes) do
    { 'delegations' =>
        [{
          'id' => '99cfd7299e01447cfe49a0748091bd4614755c64',
          'node_id' => 'NodeID-8c8MX2Y8zmgAMr64vm8LMZoxQhFq7bSHk',
          'stake_amount' => '250000000000',
          'potential_reward' => '893297004',
          'reward_address' => 'P-avax196nvvup509vm6r8dfdgtql30xsg2a89tya066l',
          'active' => true,
          'active_start_time' => '2021-01-09T21:30:39Z',
          'active_end_time' => '2021-01-23T21:30:39Z',
          'first_height' => 269569,
          'last_height' => 270355
        }],
      'stats_24h' =>
        [{ 'time' => '2021-01-10T21:00:00Z',
           'bucket' => 'h',
           'uptime_min' => 100,
           'uptime_max' => 100,
           'uptime_avg' => 100,
           'stake_amount' => 600000000000000,
           'stake_percent' => 0.2784178876699613,
           'delegations_count' => 13,
           'delegations_percent' => 0.41,
           'delegated_amount' => 143625375765389,
           'delegated_amount_percent' => 0.4 }],
      'validator' =>
        { 'node_id' => 'NodeID-8c8MX2Y8zmgAMr64vm8LMZoxQhFq7bSHk',
          'stake_amount' => '600000000000000',
          'stake_percent' => 0.2784178876699613,
          'potential_reward' => '66738322518162',
          'reward_address' => 'P-avax1zu2l0vvr9smqpzdf6tacepalj5lue79ktnxk0p',
          'active' => true,
          'active_start_time' => '2021-01-05T11:36:37Z',
          'active_end_time' => '2022-01-05T11:36:37Z',
          'active_progress_percent' => 1.487817713089802,
          'uptime' => 100,
          'delegations_count' => 13,
          'delegations_percent' => 0.40473225404732255,
          'delegated_amount' => '143625375765389',
          'delegated_amount_percent' => 0.39875021206153716,
          'delegation_fee' => 2,
          'capacity' => '2256374624234611',
          'capacity_percent' => 5.984390656891208,
          'first_height' => 270355,
          'last_height' => 270355 } }
  end

  describe '#initialize' do
    it 'gets set correctly' do
      expect(validators_summary).to be_a Avalanche::ValidatorDetails
      expect(validators_summary.validator.active_start_time).to be_a Time
      expect(validators_summary.validator.active_end_time).to be_a Time
    end
  end
end
