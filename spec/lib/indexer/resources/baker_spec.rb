require "rails_helper"
require "indexer/resources/baker"

RSpec.describe Indexer::Baker do
  describe ".count" do
    it "fetches the bakers_count from the indexer", :vcr do
      chain = create(:tezos_chain, indexer_api_base_url: "http://localhost:3000/tezos")
      count = described_class.count
      expect(count).to eq 2231
    end
  end
end
