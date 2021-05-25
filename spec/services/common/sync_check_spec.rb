require 'rails_helper'

describe Common::SyncChecker do
  subject { described_class.new('cosmos', 1, notifier) }

  let(:notifier) { double('Slack::Notifier') }
  let!(:chain) { create(:cosmos_chain) }

  context 'in sync' do
    let(:out_of_sync?) { false }

    it 'works for in sync' do
      allow(notifier).to receive(:post)
      subject.run
    end
  end

  context 'out of sync' do
    let(:out_of_sync?) { true }

    it 'works for out of sync' do
      allow(notifier).to receive(:post)
      subject.run
    end
  end
end
