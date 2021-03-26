require 'rails_helper'

RSpec.describe Livepeer::Queries::PoolRewardsPerRoundQuery, livepeer: :factory do
  subject { described_class.new(chain, params) }

  include_context 'Livepeer pool data'

  let(:chain) { chains[0] }
  let(:params) { {} }

  it 'returns pool rewards grouped by round and orchestrator' do
    results = subject.call

    expect(results.length).to eq(5)

    expect(results[0].round_number).to eq(rounds[0].number)
    expect(results[0].orchestrator_address).to eq(orchestrators[0])
    expect(results[0].reward_tokens).to eq(10)

    expect(results[1].round_number).to eq(rounds[0].number)
    expect(results[1].orchestrator_address).to eq(orchestrators[1])
    expect(results[1].reward_tokens).to eq(20)

    expect(results[2].round_number).to eq(rounds[1].number)
    expect(results[2].orchestrator_address).to eq(orchestrators[0])
    expect(results[2].reward_tokens).to eq(30)

    expect(results[3].round_number).to eq(rounds[1].number)
    expect(results[3].orchestrator_address).to eq(orchestrators[1])
    expect(results[3].reward_tokens).to eq(40)

    expect(results[4].round_number).to eq(rounds[2].number)
    expect(results[4].orchestrator_address).to eq(orchestrators[0])
    expect(results[4].reward_tokens).to eq(50)
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

      expect(results.length).to eq(2)

      expect(results[0].round_number).to eq(rounds[0].number)
      expect(results[0].orchestrator_address).to eq(orchestrators[0])
      expect(results[0].reward_tokens).to eq(10)

      expect(results[1].round_number).to eq(rounds[0].number)
      expect(results[1].orchestrator_address).to eq(orchestrators[1])
      expect(results[1].reward_tokens).to eq(20)
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

    it 'filters pools by date' do
      results = subject.call

      expect(results.length).to eq(4)

      expect(results[0].round_number).to eq(rounds[0].number)
      expect(results[0].orchestrator_address).to eq(orchestrators[0])
      expect(results[0].reward_tokens).to eq(10)

      expect(results[1].round_number).to eq(rounds[0].number)
      expect(results[1].orchestrator_address).to eq(orchestrators[1])
      expect(results[1].reward_tokens).to eq(20)

      expect(results[2].round_number).to eq(rounds[1].number)
      expect(results[2].orchestrator_address).to eq(orchestrators[0])
      expect(results[2].reward_tokens).to eq(30)

      expect(results[3].round_number).to eq(rounds[1].number)
      expect(results[3].orchestrator_address).to eq(orchestrators[1])
      expect(results[3].reward_tokens).to eq(40)
    end
  end
end
