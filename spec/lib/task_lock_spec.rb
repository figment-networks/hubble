require 'rails_helper'

describe TaskLock do
  describe '.with_lock!' do
    subject do
      described_class.new(name, id, connection_address).with_lock!(&block)
    end

    let(:name) { 'task_name' }
    let(:id) { 'task_id' }
    let(:block) { proc {} }
    let(:result) { 'some result' }
    let(:connection_address) { nil }

    context 'no connection address defined' do
      it 'calls the block' do
        expect(block).to receive(:call).and_return(result)
        expect(subject).to eq result
      end
    end

    context 'connection address is defined' do
      let(:connection_address) { '127.0.0.1:11211' }
      let(:suo_double) { double }

      it 'calls the block' do
        expect(block).to receive(:call).and_return(result)
        expect(Suo::Client::Memcached).to receive(:new).and_return(suo_double)
        expect(suo_double).to receive(:lock).and_yield
        expect(subject).to eq result
      end
    end
  end
end
