require 'rails_helper'

RSpec.describe Livepeer::Queries::StakesQuery, livepeer: :factory do
  include_context 'Livepeer delegator stakes'

  let(:delegator_list) { create_delegator_list(chains[0], delegators) }
  let(:params) { {} }

  subject { described_class.new(delegator_list, params) }

  it 'returns stakes grouped by delegator' do
    result = subject.call

    expect(result.length).to eq(2)

    expect(result[1].delegator_address).to eq(delegators[0])
    expect(result[1].pending_stake).to eq(400)
    expect(result[1].unclaimed_stake).to eq(200)

    expect(result[0].delegator_address).to eq(delegators[1])
    expect(result[0].pending_stake).to eq(600)
    expect(result[0].unclaimed_stake).to eq(300)
  end


  context 'when the range type is round' do
    let(:params) do
      {
        range_type: 'round',
        round_number: rounds[0].number
      }
    end

    it 'filters stakes by round' do
      result = subject.call

      expect(result.length).to eq(2)

      expect(result[1].delegator_address).to eq(delegators[0])
      expect(result[1].pending_stake).to eq(100)
      expect(result[1].unclaimed_stake).to eq(50)

      expect(result[0].delegator_address).to eq(delegators[1])
      expect(result[0].pending_stake).to eq(200)
      expect(result[0].unclaimed_stake).to eq(100)
    end
  end

  context 'when the range type is date' do
    let(:params) do
      {
        range_type: 'date',
        start_date: rounds[0].initialized_at.beginning_of_day,
        end_date: rounds[1].initialized_at.end_of_day
      }
    end

    it 'filters stakes by date' do
      result = subject.call

      expect(result.length).to eq(2)

      expect(result[1].delegator_address).to eq(delegators[0])
      expect(result[1].pending_stake).to eq(300)
      expect(result[1].unclaimed_stake).to eq(150)

      expect(result[0].delegator_address).to eq(delegators[1])
      expect(result[0].pending_stake).to eq(400)
      expect(result[0].unclaimed_stake).to eq(200)
    end
  end
end
