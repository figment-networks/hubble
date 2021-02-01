require 'rails_helper'

class ClientResourceTest < Common::Resource
  field :id
end

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

  describe '#get_collection' do
    let(:data) do
      [
        { id: 1 }, { id: 2 }, { id: 3 }
      ]
    end

    before do
      stub_request(:get, 'http://indexer/collection').to_return(
        status: 200,
        body: JSON.dump(data)
      )
    end

    it 'parses the response into collection of records' do
      result = client.get_collection(ClientResourceTest, '/collection')

      expect(result).to be_an Array
      expect(result.size).to eq data.size

      item = result.shift
      expect(item).to be_a ClientResourceTest
      expect(item.id).to eq 1
    end
  end
end
