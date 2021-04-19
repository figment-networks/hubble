require 'rails_helper'

describe Skale::Client do
  let(:indexer_endpoint) { 'http://skale-indexer' }
  let(:indexer_name)     { 'skale' }
  let(:client)           { described_class.new(indexer_endpoint) }

  before do
    stub_endpoint('/health', {}, 'status')
    stub_endpoint('/validators', {}, 'validators')
    stub_endpoint('/delegations', {}, 'delegations')
  end

  describe '#status' do
    let(:result) { client.status }

    it 'returns Health successful' do
      expect(result).to be_a Skale::Status
    end
  end

  describe '#validators' do
    let(:result) { client.validators }

    it 'returns validators' do
      expect(result).to be_a Array
      expect(result.first).to be_a Skale::Validator
    end
  end

  describe '#delegations' do
    let(:result) { client.delegations }

    it 'returns delegations' do
      expect(result).to be_a Array
      expect(result.first).to be_a Skale::Delegation
    end
  end
end
