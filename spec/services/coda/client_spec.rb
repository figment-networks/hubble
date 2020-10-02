require 'rails_helper'

describe Coda::Client do
  let(:indexer_endpoint) { 'http://coda-indexer' }
  let(:indexer_name)     { 'coda' }
  let(:client)           { described_class.new(indexer_endpoint) }

  before do
    stub_endpoint('/status', {}, 'status')
    stub_endpoint('/height', {}, 'height')
    stub_endpoint('/block', {}, 'current_block')
    stub_endpoint('/blocks/height', {}, 'block')
    stub_endpoint('/blocks/hash', {}, 'block')
    stub_endpoint('/blocks', { limit: 50 }, 'blocks')
    stub_endpoint('/block_stats', { period: 48, interval: 'h' }, 'block_stats')
    stub_endpoint('/block_times', { limit: 100 }, 'block_times')
    stub_endpoint('/validators', {}, 'validators')
    stub_endpoint('/validators/id', {}, 'validator')
    stub_endpoint('/accounts/id', {}, 'account')
    stub_endpoint('/transactions', { type: 'fee' }, 'transactions')
    stub_endpoint('/transactions/hash', {}, 'transaction')
    stub_endpoint('/transactions_stats', { period: 48, interval: 'h' }, 'transactions_stats')
  end

  describe '#status' do
    let(:result) { client.status }

    it 'returns current status' do
      expect(result).to be_a Coda::Status
      expect(result.app_name).to eq 'coda-indexer'
      expect(result.app_version).to eq '0.1.0'
      expect(result.git_commit).to eq '-'
      expect(result.go_version).to eq 'go1.14.4'
      expect(result.last_block_height).to eq 7388
      expect(result.last_block_time).to be_a Time
    end
  end

  describe '#current_height' do
    let(:result) { client.current_height }

    it 'returns the current height' do
      expect(result).to eq 6805
    end
  end

  describe '#current_block' do
    let(:result) { client.current_block }

    it 'returns current block' do
      expect(result).to be_a Coda::Block
      expect(result.hash).to eq 'D2rcXVQYbPfYj2D88sbRVEvqvwk8SDVmtc949SH4NSJdVncTDQ13Ep59FhGrYz6AqKaUgKjDCoVesAGHxZvx6TwiNKS1MW9CXNP9pa5iZcDNBd8aezGFNYKLzz8JVSRrpcfMFTBnNv7kM6RzWNpFqmqV5bTREM1ydBb1JafQSHK8ASDC6q5fdwqtyXijHhPzZJFo6biGEd7jwpqipxGtKF3XfR8STkPDqti95oGVoFynX9ZVNryG9PJEvciXt7xM4mAHksqwNJ31g9dYiZ1U7uhNnvCmqmgBsNbnYxeEYm8BoriVK2CAtTNhvfmEAU5Y47'
    end
  end

  describe '#block' do
    it 'returns block by hash' do
      expect(client.block('hash')).to be_a Coda::BlockDetails
    end

    it 'returns block by height' do
      expect(client.block('height')).to be_a Coda::BlockDetails
    end
  end

  describe '#blocks' do
    let(:result) { client.blocks }

    it 'returns most recent blocks' do
      expect(result).to be_a Array
      expect(result.first).to be_a Coda::Block
    end
  end

  describe '#block_stats' do
    let(:result) { client.block_stats }

    it 'returns blocks stats for a period' do
      expect(result).to be_a Array
      expect(result.first).to be_a Coda::BlockStat
    end
  end

  describe '#block_times' do
    let(:result) { client.block_times }

    it 'returns block times' do
      expect(result).to be_a Coda::BlockTime
    end
  end

  describe '#validators' do
    let(:result) { client.validators }

    it 'returns validators' do
      expect(result).to be_a Array
      expect(result.first).to be_a Coda::Validator
    end
  end

  describe '#validator' do
    let(:result) { client.validator('id') }

    it 'returns validator details' do
      expect(result).to be_a Coda::ValidatorDetails
    end
  end

  describe '#account' do
    let(:result) { client.account('id') }

    it 'returns account details' do
      expect(result).to be_a Coda::Account
    end
  end

  describe '#transactions' do
    let(:result) { client.transactions(type: 'fee') }

    it 'returns transactions' do
      expect(result).to be_an Array
      expect(result.first).to be_a Coda::Transaction
    end
  end

  describe '#transaction' do
    let(:result) { client.transaction('hash') }

    it 'returns transaction details' do
      expect(result).to be_a Coda::Transaction
    end
  end

  describe '#transaction_stats' do
    let(:result) { client.transactions_stats }

    it 'returns transactions stats' do
      expect(result).to be_a Array
      expect(result.first).to be_a Coda::TransactionStat
    end
  end
end
