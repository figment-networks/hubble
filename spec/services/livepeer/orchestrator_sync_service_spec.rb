require 'rails_helper'

RSpec.describe Livepeer::OrchestratorSyncService, livepeer: %i[graph factory] do
  subject { described_class.new(chain, data) }

  let(:chain) { create(:livepeer_chain) }

  let(:data) do
    Hashie::Mash::Rash.new(
      id: '0x0119a06b51c83d0eec79708b921a57247dc37e66',
      active: true,
      reward_cut: '20000',
      fee_Share: '50000',
      total_stake: '11949784949606643635714'
    )
  end

  before do
    allow(ThreeboxClient).to receive(:new).with(data.id) do
      double(fetch_space: json_fixture('livepeer/orchestrator_profile.json'))
    end
  end

  context 'without an existing orchestrator' do
    it 'creates a new record' do
      subject.call

      orchestrator = chain.orchestrators.take

      expect(orchestrator.address).to eq('0x0119a06b51c83d0eec79708b921a57247dc37e66')
      expect(orchestrator.active).to eq(true)
      expect(orchestrator.reward_cut).to eq(2)
      expect(orchestrator.fee_share).to eq(5)
      expect(orchestrator.total_stake).to eq(BigDecimal('11949.784949606643635714'))
      expect(orchestrator.name).to eq('Example Orchestrator')
      expect(orchestrator.description).to eq('Example Description')
      expect(orchestrator.website_url).to eq('http://orchestrator.example')
    end
  end

  context 'with an existing orchestrator' do
    let!(:orchestrator) { create_orchestrator(chain, address: data.id) }

    it "doesn't create a new record" do
      subject.call
      expect(chain.orchestrators.count).to eq(1)
    end

    it 'updates the existing record' do
      subject.call

      orchestrator.reload

      expect(orchestrator.chain).to eq(chain)
      expect(orchestrator.address).to eq('0x0119a06b51c83d0eec79708b921a57247dc37e66')
      expect(orchestrator.active).to eq(true)
      expect(orchestrator.reward_cut).to eq(2)
      expect(orchestrator.fee_share).to eq(5)
      expect(orchestrator.total_stake).to eq(BigDecimal('11949.784949606643635714'))
      expect(orchestrator.name).to eq('Example Orchestrator')
      expect(orchestrator.description).to eq('Example Description')
      expect(orchestrator.website_url).to eq('http://orchestrator.example')
    end
  end
end
