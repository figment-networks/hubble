require 'rails_helper'

RSpec.describe Livepeer::Queries::StakesQuery, livepeer: :factory do
  subject { described_class.new(delegator_list, params) }

  include_context 'Livepeer delegator stakes'

  let(:delegator_list) { create_delegator_list(chains[0], delegators) }
  let(:params) { {} }

  it 'returns stakes grouped by delegator' do
    results = subject.call

    expect(results.length).to eq(2)

    expect(results[0].delegator_address).to eq(delegators[0])
    expect(results[0].pending_stake).to eq(400)
    expect(results[0].unclaimed_stake).to eq(200)

    expect(results[1].delegator_address).to eq(delegators[1])
    expect(results[1].pending_stake).to eq(600)
    expect(results[1].unclaimed_stake).to eq(300)
  end

  context 'when the range type is round' do
    let(:params) do
      {
        range_type: 'round',
        round_number: rounds[0].number.to_s
      }
    end

    it 'filters stakes by round' do
      results = subject.call

      expect(results.length).to eq(2)

      expect(results[0].delegator_address).to eq(delegators[0])
      expect(results[0].pending_stake).to eq(100)
      expect(results[0].unclaimed_stake).to eq(50)

      expect(results[1].delegator_address).to eq(delegators[1])
      expect(results[1].pending_stake).to eq(200)
      expect(results[1].unclaimed_stake).to eq(100)
    end
  end

  context 'when the range type is date' do
    let(:params) do
      {
        range_type: 'date',
        start_date: rounds[0].initialized_at.to_date.to_s,
        end_date: rounds[1].initialized_at.to_date.to_s
      }
    end

    it 'filters stakes by date' do
      results = subject.call

      expect(results.length).to eq(2)

      expect(results[0].delegator_address).to eq(delegators[0])
      expect(results[0].pending_stake).to eq(300)
      expect(results[0].unclaimed_stake).to eq(150)

      expect(results[1].delegator_address).to eq(delegators[1])
      expect(results[1].pending_stake).to eq(400)
      expect(results[1].unclaimed_stake).to eq(200)
    end
  end
end
