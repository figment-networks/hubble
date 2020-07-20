require 'rails_helper'

RSpec.describe Livepeer::Factories::GraphQueryFactory do
  let(:resource) { :rounds }

  subject { described_class.new(resource) }

  it 'returns a graph query class' do
    expect(subject.call).to eq(Livepeer::Queries::Graph::RoundsQuery)
  end
end
