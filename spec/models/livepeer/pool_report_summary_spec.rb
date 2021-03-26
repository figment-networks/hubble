RSpec.describe Livepeer::PoolReportSummary, livepeer: :factory do
  subject { described_class.new(chain, params) }

  include_context 'Livepeer pool data'

  let(:chain) { chains[0] }
  let(:params) { {} }

  it 'returns the report data' do
    results = subject.data

    expect(results.length).to eq(2)

    expect(results[0]).to include(
      orchestrator_address: orchestrators[0],
      total_stake: 900,
      reward_tokens: 90
    )

    expect(results[1]).to include(
      orchestrator_address: orchestrators[1],
      total_stake: 600,
      reward_tokens: 60
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
        orchestrator_address: orchestrators[0],
        total_stake: 100,
        reward_tokens: 10
      )

      expect(results[1]).to include(
        orchestrator_address: orchestrators[1],
        total_stake: 200,
        reward_tokens: 20
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
        orchestrator_address: orchestrators[0],
        total_stake: 300,
        reward_tokens: 40
      )

      expect(results[1]).to include(
        orchestrator_address: orchestrators[1],
        total_stake: 400,
        reward_tokens: 60
      )
    end
  end
end
