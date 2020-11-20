require 'rails_helper'

describe Polkadot::ValidatorsSummary do
  describe '#indexing_completed?' do
    subject { validators_summary.indexing_completed?(last_indexed_timestamp) }

    let(:validators_summary) { described_class.new(attributes) }
    let(:attributes) do
      { 'time_bucket' => '2020-10-31T15:00:00Z', 'time_interval' => 'hour',
        'total_stake_avg' => 0, 'total_stake_min' => 0, 'total_stake_max' => 0, 'own_stake_avg' => 0,
        'own_stake_min' => 0, 'own_stake_max' => 0, 'stakers_stake_avg' => 0, 'stakers_stake_min' => 0,
        'stakers_stake_max' => 0, 'reward_points_avg' => 0, 'reward_points_min' => 0,
        'reward_points_max' => 0, 'commission_avg' => 0, 'commission_min' => 0, 'commission_max' => 0,
        'stakers_count_avg' => 0, 'stakers_count_min' => 0, 'stakers_count_max' => 0, 'uptime_avg' => 1 }
    end
    let(:last_indexed_timestamp) { Time.zone.parse('2020-11-31T15:00:00Z') }

    it 'returns true if indexed after time bucket' do
      expect(subject).to eq true
    end

    context 'last indexed before time bucket' do
      let(:last_indexed_timestamp) { Time.zone.parse('2020-10-30T15:00:00Z') }

      it 'returns false' do
        expect(subject).to eq false
      end
    end
  end
end
