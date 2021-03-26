require 'rails_helper'

describe Prime::MessariDataService do
  let!(:network)          { create(:prime_network, name: 'polkadot') }
  let!(:chain)            { create(:prime_chain, network: network) }

  describe '#token_metrics', :vcr do
    let(:result) { network.token_metrics! }

    it 'returns current token metrics', :vcr do
      expect(result.price_usd).to eq(30.621353819415237)
    end
  end

  describe '#token_price_time_series', :vcr do
    let(:result) { network.token_price_time_series! }

    it 'returns token price time series', :vcr do
      expect(result).to be_a Prime::TokenPriceTimeSeries
    end
  end

  describe '#network_events', :vcr do
    let(:result) { network.events! }

    it 'returns network events', :vcr do
      expect(result.first).to be_a Prime::NetworkEventDecorator
    end
  end
end
