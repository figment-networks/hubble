require 'rails_helper'

RSpec.describe Livepeer::Factories::AdapterFactory do
  subject { described_class.new(resource) }

  let(:resource) { :bonds }

  it 'returns an adapter class' do
    expect(subject.call).to eq(Livepeer::Adapters::BondAdapter)
  end
end
