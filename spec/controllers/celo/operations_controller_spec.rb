require 'rails_helper'

RSpec.describe Celo::OperationsController do
  describe 'GET #show' do
    subject { get :show, params: { network: chain.network_name.downcase, chain_id: chain.slug, id: 1, block_id: '290813', transaction_id: '0x50bfadecfebb773b01b9f0e5a171eaca58e2ac6e3024609d7997320d920b84c7' } }

    let(:chain) { create(:celo_chain) }
    let(:transaction) { double(other_operations: other_operations) }
    let(:other_operations) { [double, operation] }
    let(:operation) { double(details: { some_detail: 'value' }) }

    before do
      allow_any_instance_of(Celo::Client).to receive(:transaction).and_return(transaction)
    end

    it 'returns a json response' do
      subject
      expect(JSON.parse(response.body)).to eq({ 'some_detail' => 'value' })
    end
  end
end
