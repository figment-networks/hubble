require 'rails_helper'

RSpec.describe Livepeer::Factories::ModelFactory do
  let(:resource) { :rounds }

  subject { described_class.new(resource) }

  it 'returns a model class' do
    expect(subject.call).to eq(Livepeer::Round)
  end
end
