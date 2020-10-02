require 'rails_helper'

RSpec.describe Livepeer::Queries::SharesQuery, livepeer: :factory do
  subject { described_class.new(delegator_list, params) }

  include_context 'Livepeer delegator shares'

  let(:delegator_list) { create_delegator_list(chains[0], delegators) }
  let(:params) { {} }

  it 'returns shares grouped by delegator' do
    results = subject.call

    expect(results.length).to eq(2)

    expect(results[0].delegator_address).to eq(delegators[0])
    expect(results[0].fees).to eq(60)
    expect(results[0].reward_tokens).to eq(600)

    expect(results[1].delegator_address).to eq(delegators[1])
    expect(results[1].fees).to eq(40)
    expect(results[1].reward_tokens).to eq(400)
  end

  context 'when the range type is round' do
    let(:params) do
      {
        range_type: 'round',
        round_number: rounds[0].number.to_s
      }
    end

    it 'filters pools by round' do
      results = subject.call

      expect(results.length).to eq(1)

      expect(results[0].delegator_address).to eq(delegators[0])
      expect(results[0].fees).to eq(30)
      expect(results[0].reward_tokens).to eq(300)
    end
  end

  context 'when the range type is date' do
    let(:params) do
      {
        range_type: 'date',
        start_date: rounds[1].initialized_at.to_date.to_s,
        end_date: rounds[1].initialized_at.to_date.to_s
      }
    end

    it 'filters pools by date' do
      results = subject.call

      expect(results.length).to eq(2)

      expect(results[0].delegator_address).to eq(delegators[0])
      expect(results[0].fees).to eq(30)
      expect(results[0].reward_tokens).to eq(300)

      expect(results[1].delegator_address).to eq(delegators[1])
      expect(results[1].fees).to eq(40)
      expect(results[1].reward_tokens).to eq(400)
    end
  end
end
