require "rails_helper"

describe Near::Block do
  let(:block) { described_class.new(attrs) }
  let(:attrs) { json_fixture("near/block.json") }

  describe "#initialize" do
    it "sets timestamps" do
      expect(block.time).to be_a Time
      expect(block.created_at).to be_a Time
      expect(block.updated_at).to be_a Time
    end
  end
end
