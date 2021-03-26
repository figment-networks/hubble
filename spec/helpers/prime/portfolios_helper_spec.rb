require 'rails_helper'

describe Prime::PortfoliosHelper do
  let!(:prime_user) { create(:user, prime: true) }
  let!(:polkadot) { create(:prime_network, name: 'Polkadot') }
  let!(:oasis) { create(:prime_network, name: 'Oasis') }

  let!(:polkadot_chain) do
    create(:prime_chain,
           network: polkadot,
           name: 'Polkadot',
           slug: 'polkadot',
           api_url: 'http://localhost:2222')
  end

  let!(:oasis_chain) do
    create(:prime_chain,
           network: oasis,
           name: 'Mainnet',
           slug: 'mainnet',
           type: 'Prime::Chains::Oasis',
           api_url: 'https://localhost:1111',
           reward_token_factor: 9,
           reward_token_remote: 'rose',
           reward_token_display: 'ROSE')
  end

  let!(:polkadot_account) do
    create(:prime_account,
           user: prime_user,
           network: polkadot,
           address: '138QdRbUTB9eNY94Q4Mj5r39FkgMiyHCAy8UFMNA5gvtrfSB')
  end

  let!(:oasis_account) do
    create(:prime_account,
           user: prime_user,
           network: oasis,
           type: 'Prime::Accounts::Oasis',
           address: 'oasis1qzkdwhw4hnu2pl49c6kpm8znh83uagvh9q7l8m2w')
  end

  describe '#portfolio_balance_usd', :vcr do
    it 'returns correct balance' do
      networks = Prime::Network.enabled.order(name: :asc).map do |network|
        Prime::NetworkDecorator.new(network)
      end
      network_balances = prime_user.network_balances
      polkadot_balance = network_balances['polkadot'] * networks.select { |n| n.name == 'polkadot' }.first.price_usd
      oasis_balance = network_balances['oasis'] * networks.select { |n| n.name == 'oasis' }.first.price_usd

      result = portfolio_balance_usd(networks, network_balances)
      expect(result).to eq (polkadot_balance + oasis_balance).round(2)
    end
  end

  describe '#portfolio_one_month_roi', :vcr do
    it 'returns correct ROI' do
      networks = Prime::Network.enabled.order(name: :asc).map do |network|
        Prime::NetworkDecorator.new(network)
      end
      network_balances = prime_user.network_balances
      polkadot_roi = networks.select { |n| n.name == 'polkadot' }.first.one_month_roi
      oasis_roi = networks.select { |n| n.name == 'oasis' }.first.one_month_roi
      polkadot_change = network_balances['polkadot'] * networks.select { |n| n.name == 'polkadot' }.first.price_usd * polkadot_roi
      oasis_change = network_balances['oasis'] * networks.select { |n| n.name == 'oasis' }.first.price_usd * oasis_roi

      result = portfolio_one_month_roi(networks, network_balances)
      expect(result).to eq ((polkadot_change + oasis_change) / portfolio_balance_usd(networks, network_balances)).round(2)
    end
  end
end
