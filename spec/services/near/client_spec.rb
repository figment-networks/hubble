require 'rails_helper'

describe Near::Client do
  let(:indexer_endpoint) { 'http://near-indexer' }
  let(:indexer_name)     { 'near' }
  let(:client)           { described_class.new(indexer_endpoint) }

  before do
    stub_endpoint('/status', {}, 'status')
    stub_endpoint('/height', {}, 'height')
    stub_endpoint('/block', {}, 'block')
    stub_endpoint('/blocks/height', {}, 'block')
    stub_endpoint('/blocks/hash', {}, 'block')
    stub_endpoint('/block_times', { limit: 100 }, 'block_times')
    stub_endpoint('/block_times_interval', { period: '48', interval: 'h' }, 'block_times_interval')
    stub_endpoint('/validators', {}, 'validators')
    stub_endpoint('/validators/id', {}, 'validator')
    stub_endpoint('/validators/height', {}, 'validator')
    stub_endpoint('/validator_times_interval', { period: '48', interval: 'h' },
                  'validator_times_interval')
    stub_endpoint('/accounts/id', {}, 'account')
  end

  describe '#status' do
    let(:result) { client.status }

    it 'returns current status' do
      expect(result).to be_a Near::Status
      expect(result.app_name).to eq 'near-indexer'
      expect(result.app_version).to eq '0.1.0'
      expect(result.git_commit).to eq '-'
      expect(result.go_version).to eq '-'
      expect(result.last_block_height).to eq 6553133
      expect(result.last_block_time).to be_a Time
    end
  end

  describe '#current_height' do
    let(:result) { client.current_height }

    it 'returns current block height' do
      expect(result).to eq 6553950
    end
  end

  describe '#current_block' do
    let(:result) { client.current_block }

    it 'returns current block' do
      expect(result).to be_a Near::Block
      expect(result.height).to be_a Integer
      expect(result.app_version).to be_a String
      expect(result.time).to be_a Time
    end
  end

  describe '#block' do
    it 'returns a block' do
      expect(client.block('hash')).to be_a Near::Block
      expect(client.block('height')).to be_a Near::Block
      expect(client.block_by_hash('hash')).to be_a Near::Block
      expect(client.block_by_height('height')).to be_a Near::Block
    end
  end

  describe '#block_times' do
    let(:result) { client.block_times }

    it 'returns the block times list' do
      expect(result).to be_a Near::BlockTime
      expect(result.count).to be_a Integer
      expect(result.diff).to be_a Float
      expect(result.avg).to be_a Float
    end
  end

  describe '#block_times_interval' do
    let(:result) { client.block_times_interval }
    let(:stat)   { result.first }

    it 'returns the block times stats' do
      expect(result).to be_an Array
      expect(stat).to be_a Near::IntervalStat
      expect(stat.time_interval).to be_a Time
      expect(stat.count).to be_a Integer
      expect(stat.avg).to be_a Float
    end
  end

  describe '#validators' do
    let(:result) { client.validators }

    it 'returns validators' do
      expect(result).to be_an Array
      expect(result.first).to be_a Near::Validator
    end
  end

  describe '#validator' do
    let(:validator) { client.validator('id') }

    it 'returns validator details' do
      expect(client.validator('id')).to be_a Near::Validator
      expect(client.validator_by_height('height')).to be_a Near::Validator
    end

    it 'includes validator details' do
      expect(validator.epochs.first).to be_a Near::ValidatorEpoch
      expect(validator.account).to be_a Near::Account
      expect(validator.blocks.first).to be_a Near::Block
    end
  end

  describe '#validator_times_interval' do
    let(:result) { client.validator_times_interval }

    it 'returns validator stats' do
      expect(result).to be_an Array
      expect(result.first).to be_a Near::IntervalStat
    end
  end

  describe '#account' do
    let(:result) { client.account('id') }

    it 'returns account details' do
      expect(result).to be_a Near::Account
      expect(result.name).to be_a String
      expect(result.start_time).to be_a Time
      expect(result.last_time).to be_a Time
    end
  end
end
