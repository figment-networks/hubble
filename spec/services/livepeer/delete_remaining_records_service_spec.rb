require 'rails_helper'

RSpec.describe Livepeer::DeleteRemainingRecordsService, livepeer: :factory do
  let(:chain) { create(:livepeer_chain) }
  let(:resource) { :transcoders }
  let(:objects) do
    [
      { id: '0x5529ab0c6fc24dab504b7bbbcb7086e054c9f683' },
      { id: '0x4bb976c48fb9b5208c4d7ba0329a617a7eec94b4' }
    ]
  end

  subject { described_class.new(chain, resource, objects) }

  let!(:transcoders) do
    [
      create_transcoder(chain, address: '0x5529ab0c6fc24dab504b7bbbcb7086e054c9f683'),
      create_transcoder(chain, address: '0x4bb976c48fb9b5208c4d7ba0329a617a7eec94b4'),
      create_transcoder(chain, address: '0xa29b2f96f3b51c64c5463f2e79b744f88bf10490')
    ]
  end

  it 'deletes remaining records' do
    subject.call

    expect(chain.transcoders.count).to eq(2)

    expect(transcoders[0].reload).to be_persisted
    expect(transcoders[1].reload).to be_persisted

    expect { transcoders[2].reload }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
