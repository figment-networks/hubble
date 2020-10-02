require 'rails_helper'

describe Coda::TransactionSearch do
  let(:search) { described_class.new(attrs) }

  let(:attrs) do
    {
      type: %w[payment fee],
      account: 'acc',
      memo: 'memo',
      start_time: 'start',
      end_time: 'end',
      after_id: 'after',
      before_id: 'before',
      limit: 25
    }
  end

  describe '#initialize' do
    let(:attrs) { super().merge(limit: nil) }

    it 'assigns attributes' do
      expect(search.type).to eq %w[payment fee]
      expect(search.account).to eq 'acc'
    end

    it 'sets the default limit' do
      expect(search.limit).to eq Coda::TransactionSearch::DEFAULT_LIMIT
    end
  end

  describe '#to_hash' do
    let(:result) { search.to_hash }

    it 'returns search params hash' do
      expect(result).to eq Hash(
        account: 'acc',
        after_id: 'after',
        before_id: 'before',
        end_time: 'end',
        limit: 25,
        memo: 'memo',
        start_time: 'start',
        type: 'payment,fee'
      )
    end

    context 'with show: sent' do
      let(:attrs) { super().merge(show: 'sent') }

      it 'includes sender' do
        expect(result[:account]).to eq nil
        expect(result[:sender]).to eq 'acc'
        expect(result[:receiver]).to eq nil
      end
    end

    context 'with show: received' do
      let(:attrs) { super().merge(show: 'received') }

      it 'includes sender' do
        expect(result[:account]).to eq nil
        expect(result[:receiver]).to eq 'acc'
        expect(result[:sender]).to eq nil
      end
    end
  end
end
