require 'rails_helper'

RSpec.describe Livepeer::Factories::ModelFactory do
  subject { described_class.new(resource) }

  let(:resource) { :rounds }

  it 'returns a model class' do
    expect(subject.call).to eq(Livepeer::Round)
  end

  context 'with a conflicting top-level class' do
    let(:resource) { :delegators }

    it "doesn't return the top-level class" do
      expect(subject.call).not_to eq(Delegator)
    end

    it 'returns the model class' do
      expect(subject.call).to eq(Livepeer::Delegator)
    end
  end
end
