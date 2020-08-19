require 'rails_helper'

describe Cosmoslike::ValidatorDelegationsDecorator do
  let(:instance) { described_class.new(chain, validator) }
  let(:chain) { build(:cosmos_chain) }
  let(:validator) { double(id: 1, owner: 'cosmosowner123', info_field: 1000000) }
  let(:syncer) { double }
  let(:delegation) { { 'delegator_address' => 'cosmos2121', 'shares' => 5000 } }
  let(:unbonding) { { 'delegator_address' => 'cosmos2121', 'entries' => [{ 'balance': 1 }] } }

  context '#delegations' do
    subject { instance.delegations }

    before do
      allow(chain).to receive(:syncer).and_return(syncer)
      expect(syncer).to receive(:get_validator_delegations).with(validator.owner).and_return([delegation])
      expect(syncer).to receive(:get_validator_unbonding_delegations).with(validator.owner).and_return([unbonding])
      expect(Rails.cache).to receive(:fetch).twice.and_call_original
    end

    it 'returns decorated delegations' do
      expect(subject).to eq [
        { account: "cosmos2121", amount: 0.005, share: 0.5, status: "bonded", validator: nil },
        { account: "cosmos2121", amount: 0, status: "unbonding", validator: nil }
      ]
    end
  end
end
