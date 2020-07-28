require 'rails_helper'

RSpec.describe Livepeer::Queries::UnbondsQuery, livepeer: :factory do
  include_context 'Livepeer delegator unbonds'

  let(:delegator_list) { create_delegator_list(chains[0], delegators) }
  let(:params) { {} }

  subject { described_class.new(delegator_list, params) }

  it 'returns unbonds grouped by delegator' do
    result = subject.call

    expect(result.length).to eq(2)

    expect(result[1].delegator_address).to eq(delegators[0])
    expect(result[1].unbonded_tokens).to eq(200)

    expect(result[0].delegator_address).to eq(delegators[1])
    expect(result[0].unbonded_tokens).to eq(1000)
  end

  context 'when the range type is round' do
    let(:params) do
      {
        range_type: 'round',
        round_number: withdraw_rounds[0].number
      }
    end

    it 'filters unbonds by round' do
      result = subject.call

      expect(result.length).to eq(2)

      expect(result[1].delegator_address).to eq(delegators[0])
      expect(result[1].unbonded_tokens).to eq(200)

      expect(result[0].delegator_address).to eq(delegators[1])
      expect(result[0].unbonded_tokens).to eq(400)
    end
  end

  context 'when the range type is date' do
    let(:params) do
      {
        range_type: 'date',
        start_date: withdraw_rounds[1].initialized_at.beginning_of_day,
        end_date: withdraw_rounds[2].initialized_at.end_of_day
      }
    end

    it 'filters unbonds by date' do
      result = subject.call

      expect(result.length).to eq(1)

      expect(result[0].delegator_address).to eq(delegators[1])
      expect(result[0].unbonded_tokens).to eq(600)
    end
  end
end
