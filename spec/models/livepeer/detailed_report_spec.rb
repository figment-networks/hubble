require 'rails_helper'

RSpec.describe Livepeer::DetailedReport, livepeer: :factory do
  include_context 'Livepeer delegator data'

  let(:delegator_list) { create_delegator_list(chain, delegators) }
  let(:params) { {} }

  subject { described_class.new(delegator_list, params) }

  it 'returns the report data' do
    results = subject.data

    expect(results.length).to eq(18)

    round_numbers = results.map { |r| r[:round_number] }

    expect(round_numbers.uniq).to eq([
      'Summary',
      unbond_rounds[0].number,
      unbond_rounds[1].number,
      rebond_rounds[0].number,
      rounds[0].number,
      rounds[1].number,
      rebond_rounds[1].number,
      withdraw_rounds[0].number,
      withdraw_rounds[1].number
    ])

    empty_rows_indices = [2, 6, 7, 12, 13, 15, 16]
    empty_rows = empty_rows_indices.map { |i| results[i] }

    expect(empty_rows).to all(include(
      fees: 0,
      reward_tokens: 0,
      pending_stake: 0,
      unclaimed_stake: 0,
      unbonding_tokens: 0,
      unbonded_tokens: 0
    ))

    expect(results[0]).to include(
      round_number: 'Summary',
      delegator_address: delegators[0],
      fees: 40,
      reward_tokens: 400,
      pending_stake: 400,
      unclaimed_stake: 200,
      unbonding_tokens: 1500,
      unbonded_tokens: 800
    )

    expect(results[1]).to include(
      round_number: 'Summary',
      delegator_address: delegators[1],
      fees: 60,
      reward_tokens: 600,
      pending_stake: 600,
      unclaimed_stake: 300,
      unbonding_tokens: 1400,
      unbonded_tokens: 1000
    )

    expect(results[3]).to include(
      round_number: unbond_rounds[0].number,
      delegator_address: delegators[1],
      fees: 0,
      reward_tokens: 0,
      pending_stake: 0,
      unclaimed_stake: 0,
      unbonding_tokens: 200,
      unbonded_tokens: 0
    )

    expect(results[4]).to include(
      round_number: unbond_rounds[1].number,
      delegator_address: delegators[0],
      fees: 0,
      reward_tokens: 0,
      pending_stake: 0,
      unclaimed_stake: 0,
      unbonding_tokens: 300,
      unbonded_tokens: 0
    )

    expect(results[5]).to include(
      round_number: unbond_rounds[1].number,
      delegator_address: delegators[1],
      fees: 0,
      reward_tokens: 0,
      pending_stake: 0,
      unclaimed_stake: 0,
      unbonding_tokens: 400,
      unbonded_tokens: 0
    )

    expect(results[8]).to include(
      round_number: rounds[0].number,
      delegator_address: delegators[0],
      fees: 10,
      reward_tokens: 100,
      pending_stake: 100,
      unclaimed_stake: 50,
      unbonding_tokens: 500,
      unbonded_tokens: 0
    )

    expect(results[9]).to include(
      round_number: rounds[0].number,
      delegator_address: delegators[1],
      fees: 20,
      reward_tokens: 200,
      pending_stake: 200,
      unclaimed_stake: 100,
      unbonding_tokens: 0,
      unbonded_tokens: 200
    )

    expect(results[10]).to include(
      round_number: rounds[1].number,
      delegator_address: delegators[0],
      fees: 30,
      reward_tokens: 300,
      pending_stake: 300,
      unclaimed_stake: 150,
      unbonding_tokens: 700,
      unbonded_tokens: 300
    )

    expect(results[11]).to include(
      round_number: rounds[1].number,
      delegator_address: delegators[1],
      fees: 40,
      reward_tokens: 400,
      pending_stake: 400,
      unclaimed_stake: 200,
      unbonding_tokens: 800,
      unbonded_tokens: 0
    )

    expect(results[14]).to include(
      round_number: withdraw_rounds[0].number,
      delegator_address: delegators[0],
      fees: 0,
      reward_tokens: 0,
      pending_stake: 0,
      unclaimed_stake: 0,
      unbonding_tokens: 0,
      unbonded_tokens: 500
    )

    expect(results[17]).to include(
      round_number: withdraw_rounds[1].number,
      delegator_address: delegators[1],
      fees: 0,
      reward_tokens: 0,
      pending_stake: 0,
      unclaimed_stake: 0,
      unbonding_tokens: 0,
      unbonded_tokens: 800
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
        round_number: rounds[0].number,
        delegator_address: delegators[0],
        fees: 10,
        reward_tokens: 100,
        pending_stake: 100,
        unclaimed_stake: 50,
        unbonding_tokens: 500,
        unbonded_tokens: 0
      )

      expect(results[1]).to include(
        round_number: rounds[0].number,
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

      expect(results.length).to eq(6)

      expect(results[0]).to include(
        round_number: 'Summary',
        delegator_address: delegators[0],
        fees: 40,
        reward_tokens: 400,
        pending_stake: 300,
        unclaimed_stake: 150,
        unbonding_tokens: 1200,
        unbonded_tokens: 300
      )

      expect(results[1]).to include(
        round_number: 'Summary',
        delegator_address: delegators[1],
        fees: 60,
        reward_tokens: 600,
        pending_stake: 400,
        unclaimed_stake: 200,
        unbonding_tokens: 800,
        unbonded_tokens: 200
      )

      expect(results[2]).to include(
        round_number: rounds[0].number,
        delegator_address: delegators[0],
        fees: 10,
        reward_tokens: 100,
        pending_stake: 100,
        unclaimed_stake: 50,
        unbonding_tokens: 500,
        unbonded_tokens: 0
      )

      expect(results[3]).to include(
        round_number: rounds[0].number,
        delegator_address: delegators[1],
        fees: 20,
        reward_tokens: 200,
        pending_stake: 200,
        unclaimed_stake: 100,
        unbonding_tokens: 0,
        unbonded_tokens: 200
      )

      expect(results[4]).to include(
        round_number: rounds[1].number,
        delegator_address: delegators[0],
        fees: 30,
        reward_tokens: 300,
        pending_stake: 300,
        unclaimed_stake: 150,
        unbonding_tokens: 700,
        unbonded_tokens: 300
      )

      expect(results[5]).to include(
        round_number: rounds[1].number,
        delegator_address: delegators[1],
        fees: 40,
        reward_tokens: 400,
        pending_stake: 400,
        unclaimed_stake: 200,
        unbonding_tokens: 800,
        unbonded_tokens: 0
      )
    end
  end
end
