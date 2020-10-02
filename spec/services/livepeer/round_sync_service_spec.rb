require 'rails_helper'

RSpec.describe Livepeer::RoundSyncService, livepeer: :graph do
  subject { described_class.new(chain, data) }

  let(:chain) { create(:livepeer_chain) }

  let(:data) do
    Hashie::Mash::Rash.new(
      id: '1666',
      mintable_tokens: '17774867900755010381877',
      start_block: '9596160',
      pools: [
        {
          delegate: {
            id: '0x0119a06b51c83d0eec79708b921a57247dc37e66'
          },
          fees: nil,
          reward_tokens: '16761700430411974790',
          shares: [
            {
              delegator: {
                id: '0x0119a06b51c83d0eec79708b921a57247dc37e66'
              },
              fees: nil,
              reward_tokens: '337977228500680718'
            }
          ],
          total_stake: '11933023249176231660924'
        }
      ],
      timestamp: '1583211347'
    )
  end

  before do
    stub_graph_query(Livepeer::Queries::Graph::StakesQuery)
    stub_graph_query(Livepeer::Queries::Graph::BondsQuery)
    stub_graph_query(Livepeer::Queries::Graph::UnbondsQuery)
    stub_graph_query(Livepeer::Queries::Graph::RebondsQuery)
    stub_graph_query(Livepeer::Queries::Graph::RewardCutChangesQuery)
    stub_graph_query(Livepeer::Queries::Graph::MissedRewardCallsQuery)
    stub_graph_query(Livepeer::Queries::Graph::DeactivationsQuery)
    stub_graph_query(Livepeer::Queries::Graph::SlashingsQuery)
  end

  context 'without an existing round' do
    it 'creates a new record' do
      subject.call

      round = chain.rounds.take

      expect(round.number).to eq(1666)
      expect(round.initialized_at).to eq('2020-03-03 04:55:47')
      expect(round.mintable_tokens).to eq(BigDecimal('17774.867900755010381877'))

      expect(round.pools.count).to eq(1)

      expect(round.pools[0].orchestrator_address).to eq(data.pools[0].delegate.id)
      expect(round.pools[0].total_stake).to eq(BigDecimal('11933.023249176231660924'))
      expect(round.pools[0].fees).to eq(nil)
      expect(round.pools[0].reward_tokens).to eq(BigDecimal('16.761700430411974790'))

      expect(round.pools[0].shares.count).to eq(1)

      expect(round.pools[0].shares[0].delegator_address).to eq('0x0119a06b51c83d0eec79708b921a57247dc37e66')
      expect(round.pools[0].shares[0].fees).to eq(nil)
      expect(round.pools[0].shares[0].reward_tokens).to eq(BigDecimal('0.337977228500680718'))

      expect(round.stakes.count).to eq(3)
      expect(round.bonds.count).to eq(3)
      expect(round.unbonds.count).to eq(2)
      expect(round.rebonds.count).to eq(2)

      expect(round.reward_cut_changes.count).to eq(2)
      expect(round.missed_reward_calls.count).to eq(2)
      expect(round.deactivations.count).to eq(2)
      expect(round.slashings.count).to eq(2)
    end
  end

  context 'with an existing round' do
    let!(:round) { create(:livepeer_round, chain: chain, number: 1666) }

    it "doesn't create a new record" do
      subject.call
      expect(chain.rounds.count).to eq(1)
    end

    it "doesn't update the existing record" do
      subject.call

      round.reload

      expect(round.chain).to eq(chain)
      expect(round.number).to eq(1666)

      expect(round.initialized_at).not_to eq('2020-03-03 04:55:47')
      expect(round.mintable_tokens).not_to eq(BigDecimal('17774.867900755010381877'))

      expect(round.pools).to be_empty
      expect(round.stakes).to be_empty
      expect(round.bonds).to be_empty
      expect(round.unbonds).to be_empty
      expect(round.rebonds).to be_empty

      expect(round.reward_cut_changes).to be_empty
      expect(round.missed_reward_calls).to be_empty
      expect(round.deactivations).to be_empty
      expect(round.slashings).to be_empty
    end
  end
end
