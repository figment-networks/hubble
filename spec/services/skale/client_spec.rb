require 'rails_helper'

describe Skale::Client do
  let(:indexer_endpoint) { 'http://skale-indexer' }
  let(:indexer_name)     { 'skale' }
  let(:client)           { described_class.new(indexer_endpoint) }

  before do
    stub_endpoint('/health', {}, 'status')
    stub_endpoint('/validators', {}, 'validators')
    stub_endpoint('/delegations', {}, 'delegations')
    stub_endpoint('/nodes', {}, 'nodes')
    stub_endpoint('/summary', {}, 'delegation_summary')
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

  describe '#nodes' do
    let(:result) { client.nodes }

    it 'returns nodes' do
      expect(result).to be_a Array
      expect(result.first).to be_a Skale::Node
    end
  end

  describe '#summary' do
    let(:result) { client.delegation_summary }

    it 'returns summary' do
      expect(result).to be_a Array
      expect(result.first).to be_a Skale::DelegationSummary
    end
  end
end
