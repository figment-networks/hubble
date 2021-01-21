require 'rails_helper'

describe Oasis::Client do
  let(:chain)            { create(:oasis_chain, api_url: 'http://oasis-indexer') }
  let(:indexer_endpoint) { 'http://oasis-indexer' }
  let(:indexer_name)     { 'oasis' }
  let(:client)           { described_class.new(indexer_endpoint) }

  before do
    stub_endpoint('/status', {}, 'status')
    stub_endpoint('/block', {}, 'block')
    stub_endpoint('/block', { height: 406392 }, 'block')
    stub_endpoint('/block_times/100', {}, 'block_times')
    stub_endpoint('/blocks_summary', { period: '48 hours', interval: 'hour' }, 'blocks_summary')
    stub_endpoint('/staking', { height: 406392 }, 'staking')
    stub_endpoint('/validators/for_min_height/1', {}, 'validators')
    stub_endpoint('/validator/oasis1qp22l6gy0u2cp6krh4ruuezf09f20t0qkupkhq2g',
                  { sequences_limit: 50 }, 'validator')
    stub_endpoint('/validators', { height: 406392 }, 'validators_for_height')
    stub_endpoint('/validators_summary',
                  { period: '48 hours', interval: 'hour', address: 'oasis1qp22l6gy0u2cp6krh4ruuezf09f20t0qkupkhq2g' }, 'validators_summary')
    stub_endpoint('/account/oasis1qp22l6gy0u2cp6krh4ruuezf09f20t0qkupkhq2g', {}, 'account')
    stub_endpoint('/delegations', {}, 'delegations')
    stub_endpoint('/debonding_delegations', {}, 'debonding_delegations')
    stub_endpoint('/transactions', { height: 406392 }, 'transactions')
    stub_endpoint('/transactions', { height: 406392, public_key: 123456 }, 'transactions')
    stub_endpoint('/system_events/oasis1qp22l6gy0u2cp6krh4ruuezf09f20t0qkupkhq2g', { after: 50 }, 'system_events')
    stub_endpoint('/balance/oasis1qp22l6gy0u2cp6krh4ruuezf09f20t0qkupkhq2g', {}, 'rewards')
  end

  describe '#status' do
    let(:result) { client.status }

    it 'returns current status' do
      expect(result).to be_a Oasis::Status
      expect(result.app_name).to eq 'oasishub-indexer'
      expect(result.app_version).to eq '0.5.2'
      expect(result.go_version).to eq '1.14'
      expect(result.last_indexed_height).to eq 406392
      expect(result.last_indexed_time).to be_a Time
    end
  end

  describe '#current_block' do
    let(:result) { client.current_block }

    it 'returns current block' do
      expect(result).to be_a Oasis::Block
      expect(result.height).to be_a Integer
      expect(result.app_version).to be_a Integer
      expect(result.time).to be_a Time
    end
  end

  describe '#block' do
    it 'returns a block' do
      expect(client.block(406392)).to be_a Oasis::Block
    end
  end

  describe '#block_times' do
    let(:result) { client.block_times }

    it 'returns the block times list' do
      expect(result).to be_a Oasis::BlockTime
      expect(result.count).to be_a Integer
      expect(result.diff).to be_a Integer
      expect(result.avg).to be_a Float
    end
  end

  describe '#blocks_summary' do
    let(:result) { client.blocks_summary }
    let(:stat)   { result.first }

    it 'returns the block times stats' do
      expect(result).to be_an Array
      expect(stat).to be_a Oasis::IntervalStat
      expect(stat.count).to be_a Integer
      expect(stat.block_time_avg).to be_a Float
    end
  end

  describe '#staking' do
    let(:result) { client.staking(406392) }

    it 'returns staking info' do
      expect(result).to be_a Oasis::Staking
      expect(result.common_pool).to be_a Integer
    end
  end

  describe '#validators' do
    let(:result) { client.validators }

    it 'returns validators' do
      expect(result).to be_an Array
      expect(result.first).to be_a Oasis::Validator
    end
  end

  describe '#validator' do
    let(:validator) { client.validator('oasis1qp22l6gy0u2cp6krh4ruuezf09f20t0qkupkhq2g', 50) }

    it 'returns validator details' do
      expect(validator).to be_a Oasis::Validator
      expect(validator.recent_at).to be_a Time
      expect(validator.recent_active_escrow_balance).to be_a Integer
      expect(validator.uptime).to be_a Float
      expect(validator.last_sequences).to be_a Array
    end
  end

  describe '#validators_by_height' do
    let(:validators) { client.validators_by_height(406392) }
    let(:validator) { validators.first }

    it 'returns validators list' do
      expect(validators).to be_a Array
      expect(validator).to be_a Oasis::Validator
    end
  end

  describe '#validators_summary' do
    let(:result) do
      client.validators_summary('hour', '48 hours', 'oasis1qp22l6gy0u2cp6krh4ruuezf09f20t0qkupkhq2g')
    end
    let(:stat) { result.first }

    it 'returns the block times stats' do
      expect(result).to be_an Array
      expect(stat).to be_a Oasis::IntervalStat
      expect(stat.active_escrow_balance_avg).to be_a Integer
      expect(stat.uptime_avg).to be_a Float
    end
  end

  describe '#accounts' do
    let(:account) { client.account('oasis1qp22l6gy0u2cp6krh4ruuezf09f20t0qkupkhq2g') }

    it 'returns the account' do
      expect(account).to be_an Oasis::Account
      expect(account.delegations.first).to be_a Oasis::Delegation
    end
  end

  describe '#transactions' do
    let(:result) { client.transactions(406392) }

    it 'returns transactions list' do
      expect(result.first).to be_a Oasis::Transaction
    end
  end

  describe '#transaction' do
    let(:transaction) { client.transaction(406392, 'tMq04eAJOE9tlfnyWuQCoWZhhZl0alSRu/jcpMcMSiM=') }

    it 'returns the transaction' do
      expect(transaction).to be_a Oasis::Transaction
      expect(transaction.fee).to be_a Integer
      expect(transaction.gas_limit).to be_a Integer
      expect(transaction.gas_price).to be_a Integer
      expect(transaction.nonce).to be_a Integer
    end
  end

  describe '#validator_events' do
    let(:validator_events) do
      client.validator_events(chain, 'oasis1qp22l6gy0u2cp6krh4ruuezf09f20t0qkupkhq2g', 50)
    end

    it 'returns validator_events list' do
      expect(validator_events).to be_a Array
      expect(validator_events.first).to be_a Common::Event::ActiveSetInclusion
    end
  end

  describe '#rewards' do
    let!(:rewards) { client.rewards('oasis1qp22l6gy0u2cp6krh4ruuezf09f20t0qkupkhq2g') }
    let(:reward) { rewards.first }

    it 'returns the rewards' do
      expect(rewards).to be_a Array
      expect(reward).to be_a Oasis::RewardsReport
      expect(reward.time_bucket).to be_a Time
      expect(reward.total_rewards).to be_a Integer
      expect(reward.total_commission).to be_a Integer
      expect(reward.total_slashed).to be_a Integer
    end
  end
end
