require 'rails_helper'

RSpec.describe Prime::Network do
  let!(:user) { create(:user) }
  let!(:network) { create(:prime_network) }
  let!(:chain) { create(:prime_chain, network: network) }
  let!(:account) { create(:prime_account, network: network, user: user) }

  describe 'prime network' do
    it 'has many chains' do
      expect(Prime::Network.reflect_on_association(:chains).macro).to eq(:has_many)
      expect(network.chains.count).to eq(1)
    end

    it 'has many accounts' do
      expect(Prime::Network.reflect_on_association(:accounts).macro).to eq(:has_many)
      expect(network.accounts.count).to eq(1)
    end
  end
end
