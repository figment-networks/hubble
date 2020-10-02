require 'rails_helper'

RSpec.describe Livepeer::DeleteRemainingRecordsService, livepeer: :factory do
  subject { described_class.new(chain, resource, objects) }

  let(:chain) { create(:livepeer_chain) }
  let(:resource) { :orchestrators }

  let(:objects) do
    [
      { id: '0x5529ab0c6fc24dab504b7bbbcb7086e054c9f683' },
      { id: '0x4bb976c48fb9b5208c4d7ba0329a617a7eec94b4' }
    ]
  end

  let!(:orchestrators) do
    [
      create_orchestrator(chain, address: '0x5529ab0c6fc24dab504b7bbbcb7086e054c9f683'),
      create_orchestrator(chain, address: '0x4bb976c48fb9b5208c4d7ba0329a617a7eec94b4'),
      create_orchestrator(chain, address: '0xa29b2f96f3b51c64c5463f2e79b744f88bf10490')
    ]
  end

  it 'deletes remaining records' do
    subject.call

    expect(chain.orchestrators.count).to eq(2)

    expect(orchestrators[0].reload).to be_persisted
    expect(orchestrators[1].reload).to be_persisted

    expect { orchestrators[2].reload }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
