require 'rails_helper'

RSpec.describe Livepeer::DelegatorSyncService, livepeer: :factory do
  let(:chain) { create(:livepeer_chain) }

  let(:data) do
    Hashie::Mash::Rash.new(
      id: '0x000817415963a38c16ba6ccc98f4002684c97697',
      delegate: {
        id: '0xa20416801ac2eacf2372e825b4a90ef52490c2bb'
      }
    )
  end

  subject { described_class.new(chain, data) }

  context 'without an existing delegator' do
    it 'creates a new record' do
      subject.call

      delegator = chain.delegators.take

      expect(delegator.address).to eq('0x000817415963a38c16ba6ccc98f4002684c97697')
      expect(delegator.transcoder_address).to eq('0xa20416801ac2eacf2372e825b4a90ef52490c2bb')
    end
  end

  context 'with an existing delegator' do
    let!(:delegator) { create_delegator(chain, address: data.id) }

    it "doesn't create a new record" do
      subject.call
      expect(chain.delegators.count).to eq(1)
    end

    it 'updates the existing record' do
      subject.call

      delegator.reload

      expect(delegator.chain).to eq(chain)
      expect(delegator.address).to eq('0x000817415963a38c16ba6ccc98f4002684c97697')
      expect(delegator.transcoder_address).to eq('0xa20416801ac2eacf2372e825b4a90ef52490c2bb')
    end
  end
end
