require 'rails_helper'

RSpec.describe Livepeer::Factories::SyncServiceFactory do
  subject { described_class.new(resource) }

  let(:resource) { :orchestrators }

  it 'returns a synchronization service class' do
    expect(subject.call).to eq(Livepeer::OrchestratorSyncService)
  end
end
