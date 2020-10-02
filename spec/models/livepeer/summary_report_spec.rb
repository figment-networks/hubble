require 'rails_helper'

RSpec.describe Livepeer::SummaryReport, livepeer: :factory do
  subject { described_class.new(delegator_list, params) }

  include_context 'Livepeer delegator data'

  let(:delegator_list) { create_delegator_list(chain, delegators) }
  let(:params) { {} }

  it 'returns the report data' do
    results = subject.data

    expect(results.length).to eq(2)

    expect(results[0]).to include(
      delegator_address: delegators[0],
      fees: 40,
      reward_tokens: 400,
      pending_stake: 400,
      unclaimed_stake: 200,
      unbonding_tokens: 1500,
      unbonded_tokens: 800
    )

    expect(results[1]).to include(
      delegator_address: delegators[1],
      fees: 60,
      reward_tokens: 600,
      pending_stake: 600,
      unclaimed_stake: 300,
      unbonding_tokens: 1400,
      unbonded_tokens: 1000
    )
  end

  context 'when the range type is round' do
    let(:params) do
      {
        range_type: 'round',
        round_number: rounds[0].number.to_s
      }
    end

    it 'returns the report data' do
      results = subject.data

      expect(results.length).to eq(2)

      expect(results[0]).to include(
        delegator_address: delegators[0],
        fees: 10,
        reward_tokens: 100,
        pending_stake: 100,
        unclaimed_stake: 50,
        unbonding_tokens: 500,
        unbonded_tokens: 0
      )

      expect(results[1]).to include(
        delegator_address: delegators[1],
        fees: 20,
        reward_tokens: 200,
        pending_stake: 200,
        unclaimed_stake: 100,
        unbonding_tokens: 0,
        unbonded_tokens: 200
      )
    end
  end

  context 'when the range type is date' do
    let(:params) do
      {
        range_type: 'date',
        start_date: rounds[0].initialized_at.beginning_of_day.to_s,
        end_date: rounds[1].initialized_at.end_of_day.to_s
      }
    end

    it 'returns the report data' do
      results = subject.data

      expect(results.length).to eq(2)

      expect(results[0]).to include(
        delegator_address: delegators[0],
        fees: 40,
        reward_tokens: 400,
        pending_stake: 300,
        unclaimed_stake: 150,
        unbonding_tokens: 1200,
        unbonded_tokens: 300
      )

      expect(results[1]).to include(
        delegator_address: delegators[1],
        fees: 60,
        reward_tokens: 600,
        pending_stake: 400,
        unclaimed_stake: 200,
        unbonding_tokens: 800,
        unbonded_tokens: 200
      )
    end
  end
end
