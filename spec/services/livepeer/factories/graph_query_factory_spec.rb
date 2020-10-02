require 'rails_helper'

RSpec.describe Livepeer::Factories::GraphQueryFactory do
  subject { described_class.new(resource) }

  let(:resource) { :reward_cut_changes }

  it 'returns a graph query class' do
    expect(subject.call).to eq(Livepeer::Queries::Graph::RewardCutChangesQuery)
  end
end
