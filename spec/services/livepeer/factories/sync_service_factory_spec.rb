require 'rails_helper'

RSpec.describe Livepeer::Factories::SyncServiceFactory do
  let(:resource) { :transcoders }

  subject { described_class.new(resource) }

  it 'returns a synchronization service class' do
    expect(subject.call).to eq(Livepeer::TranscoderSyncService)
  end
end
