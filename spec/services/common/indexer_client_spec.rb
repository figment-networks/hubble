require 'rails_helper'

describe Common::IndexerClient do
  let(:client) { described_class.new('http://indexer') }

  describe '#get' do
    let(:result) { client.get('/endpoint') }

    before do
      stub_request(:get, 'http://indexer/endpoint').to_return(
        status: status,
        body: body
      )
    end

    context 'on success' do
      let(:status) { 200 }
      let(:body)   { JSON.dump(foo: 'bar') }

      it 'returns decoded json data' do
        expect(result).to be_a Hash
        expect(result['foo']).to eq 'bar'
      end
    end

    context 'on bad request' do
      let(:status) { 400 }
      let(:body)   { JSON.dump(error: 'invalid request') }

      it 'raises an error' do
        expect { result }.
          to raise_error(Common::IndexerClient::Error, 'invalid request')
      end
    end

    context 'on server error' do
      let(:status) { 500 }
      let(:body)   { 'BOOM' }

      it 'raises an error' do
        expect { result }.
          to raise_error(Common::IndexerClient::Error, '500 Internal Server Error')
      end
    end
  end
end
