require 'rails_helper'

RSpec.describe Livepeer::Strategies::IgnoreExistingStrategy do
  subject { described_class.new(relation, attributes) }

  let!(:chain) { create(:livepeer_chain) }

  let(:relation) { chain.rounds.where(number: attributes[:number]) }

  let(:attributes) do
    {
      number: 1000,
      mintable_tokens: 30_000_000,
      initialized_at: 5.days.ago
    }
  end

  context 'without an existing record' do
    it 'creates a new record' do
      subject.call

      round = relation.take

      expect(round.number).to eq(attributes[:number])
      expect(round.mintable_tokens).to eq(attributes[:mintable_tokens])
      expect(round.initialized_at.to_i).to eq(attributes[:initialized_at].to_i)
    end
  end

  context 'with an existing record' do
    let!(:round) { create(:livepeer_round, chain: chain, number: attributes[:number]) }

    it "doesn't create a new record" do
      subject.call
      expect(chain.rounds.count).to eq(1)
    end

    it "doesn't update the existing record" do
      subject.call

      round.reload

      expect(round.chain).to eq(chain)
      expect(round.number).to eq(attributes[:number])

      expect(round.mintable_tokens).not_to eq(attributes[:mintable_tokens])
      expect(round.initialized_at.to_i).not_to eq(attributes[:initialized_at].to_i)
    end
  end
end
