require 'rails_helper'

RSpec.describe Livepeer::TranscoderSyncService, livepeer: [:graph, :factory] do
  let(:chain) { create(:livepeer_chain) }

  let(:data) do
    {
      id: '0x0119a06b51c83d0eec79708b921a57247dc37e66',
      active: true,
      reward_cut: '20000',
      fee_Share: '50000',
      total_stake: '11949784949606643635714'
    }
  end

  subject { described_class.new(chain, data) }

  before do
    allow(ThreeboxClient).to receive(:new).with(data[:id]) do
      double(fetch_space: load_json_fixture(:transcoder_profile))
    end
  end

  context 'without an existing transcoder' do
    it 'creates a new record' do
      subject.call

      transcoder = chain.transcoders.take

      expect(transcoder.address).to eq(data[:id])
      expect(transcoder.active).to eq(true)
      expect(transcoder.reward_cut).to eq(2)
      expect(transcoder.fee_share).to eq(5)
      expect(transcoder.total_stake).to eq(BigDecimal('11949.784949606643635714'))
      expect(transcoder.name).to eq('Example Transcoder')
      expect(transcoder.description).to eq('Example Description')
    end
  end

  context 'with an existing transcoder' do
    let!(:transcoder) { create_transcoder(chain, address: data[:id]) }

    it "doesn't create a new record" do
      subject.call
      expect(chain.transcoders.count).to eq(1)
    end

    it 'updates the existing record' do
      subject.call

      transcoder.reload

      expect(transcoder.chain).to eq(chain)
      expect(transcoder.address).to eq(data[:id])
      expect(transcoder.active).to eq(true)
      expect(transcoder.reward_cut).to eq(2)
      expect(transcoder.fee_share).to eq(5)
      expect(transcoder.total_stake).to eq(BigDecimal('11949.784949606643635714'))
      expect(transcoder.name).to eq('Example Transcoder')
      expect(transcoder.description).to eq('Example Description')
    end
  end
end
