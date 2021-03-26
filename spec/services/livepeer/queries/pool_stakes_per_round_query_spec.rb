require 'rails_helper'

RSpec.describe Livepeer::Queries::PoolStakesPerRoundQuery, livepeer: :factory do
  subject { described_class.new(chain, params) }

  include_context 'Livepeer pool data'

  let(:chain) { chains[0] }
  let(:params) { {} }

  it 'returns pool stakes grouped by round and orchestrator' do
    results = subject.call

    expect(results.length).to eq(5)

    expect(results[0].round_number).to eq(rounds[0].number)
    expect(results[0].orchestrator_address).to eq(orchestrators[0])
    expect(results[0].total_stake).to eq(100)

    expect(results[1].round_number).to eq(rounds[0].number)
    expect(results[1].orchestrator_address).to eq(orchestrators[1])
    expect(results[1].total_stake).to eq(200)

    expect(results[2].round_number).to eq(rounds[1].number)
    expect(results[2].orchestrator_address).to eq(orchestrators[0])
    expect(results[2].total_stake).to eq(300)

    expect(results[3].round_number).to eq(rounds[1].number)
    expect(results[3].orchestrator_address).to eq(orchestrators[1])
    expect(results[3].total_stake).to eq(400)

    expect(results[4].round_number).to eq(rounds[2].number)
    expect(results[4].orchestrator_address).to eq(orchestrators[0])
    expect(results[4].total_stake).to eq(500)
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
      expect(results[0].total_stake).to eq(100)

      expect(results[1].round_number).to eq(rounds[0].number)
      expect(results[1].orchestrator_address).to eq(orchestrators[1])
      expect(results[1].total_stake).to eq(200)
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
      expect(results[0].total_stake).to eq(100)

      expect(results[1].round_number).to eq(rounds[0].number)
      expect(results[1].orchestrator_address).to eq(orchestrators[1])
      expect(results[1].total_stake).to eq(200)

      expect(results[2].round_number).to eq(rounds[1].number)
      expect(results[2].orchestrator_address).to eq(orchestrators[0])
      expect(results[2].total_stake).to eq(300)

      expect(results[3].round_number).to eq(rounds[1].number)
      expect(results[3].orchestrator_address).to eq(orchestrators[1])
      expect(results[3].total_stake).to eq(400)
    end
  end
end
