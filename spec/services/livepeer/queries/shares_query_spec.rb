require 'rails_helper'

RSpec.describe Livepeer::Queries::SharesQuery, livepeer: :factory do
  include_context 'Livepeer delegator shares'

  let(:delegator_list) { create_delegator_list(chains[0], delegators) }
  let(:params) { {} }

  subject { described_class.new(delegator_list, params) }

  it 'returns shares grouped by delegator' do
    result = subject.call

    expect(result.length).to eq(2)

    expect(result[1].delegator_address).to eq(delegators[0])
    expect(result[1].fees).to eq(60)
    expect(result[1].reward_tokens).to eq(600)

    expect(result[0].delegator_address).to eq(delegators[1])
    expect(result[0].fees).to eq(40)
    expect(result[0].reward_tokens).to eq(400)
  end

  context 'when the range type is round' do
    let(:params) do
      {
        range_type: 'round',
        round_number: rounds[0].number
      }
    end

    it 'filters pools by round' do
      result = subject.call

      expect(result.length).to eq(1)

      expect(result[0].delegator_address).to eq(delegators[0])
      expect(result[0].fees).to eq(30)
      expect(result[0].reward_tokens).to eq(300)
    end
  end

  context 'when the range type is date' do
    let(:params) do
      {
        range_type: 'date',
        start_date: rounds[1].initialized_at.beginning_of_day,
        end_date: rounds[1].initialized_at.end_of_day
      }
    end

    it 'filters pools by date' do
      result = subject.call

      expect(result.length).to eq(2)

      expect(result[1].delegator_address).to eq(delegators[0])
      expect(result[1].fees).to eq(30)
      expect(result[1].reward_tokens).to eq(300)

      expect(result[0].delegator_address).to eq(delegators[1])
      expect(result[0].fees).to eq(40)
      expect(result[0].reward_tokens).to eq(400)
    end
  end
end
