require 'rails_helper'

RSpec.describe Livepeer::Factories::AdapterFactory do
  let(:resource) { :bonds }

  subject { described_class.new(resource) }

  it 'returns an adapter class' do
    expect(subject.call).to eq(Livepeer::Adapters::BondAdapter)
  end
end
