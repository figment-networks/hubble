require 'rails_helper'

RSpec.describe Livepeer::Queries::UnbondsQuery, livepeer: :factory do
  subject { described_class.new(delegator_list, params) }

  include_context 'Livepeer delegator unbonds'

  let(:delegator_list) { create_delegator_list(chains[0], delegators) }
  let(:params) { {} }

  it 'returns unbonds grouped by delegator' do
    results = subject.call

    expect(results.length).to eq(2)

    expect(results[0].delegator_address).to eq(delegators[0])
    expect(results[0].unbonded_tokens).to eq(200)

    expect(results[1].delegator_address).to eq(delegators[1])
    expect(results[1].unbonded_tokens).to eq(1000)
  end

  context 'when the range type is round' do
    let(:params) do
      {
        range_type: 'round',
        round_number: withdraw_rounds[0].number.to_s
      }
    end

    it 'filters unbonds by round' do
      results = subject.call

      expect(results.length).to eq(2)

      expect(results[0].delegator_address).to eq(delegators[0])
      expect(results[0].unbonded_tokens).to eq(200)

      expect(results[1].delegator_address).to eq(delegators[1])
      expect(results[1].unbonded_tokens).to eq(400)
    end
  end

  context 'when the range type is date' do
    let(:params) do
      {
        range_type: 'date',
        start_date: withdraw_rounds[1].initialized_at.to_date.to_s,
        end_date: withdraw_rounds[2].initialized_at.to_date.to_s
      }
    end

    it 'filters unbonds by date' do
      results = subject.call

      expect(results.length).to eq(1)

      expect(results[0].delegator_address).to eq(delegators[1])
      expect(results[0].unbonded_tokens).to eq(600)
    end
  end
end
