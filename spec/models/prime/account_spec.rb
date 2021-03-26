require 'rails_helper'

RSpec.describe Prime::Network do
  let!(:user) { create(:user) }
  let!(:network) { create(:prime_network) }
  let!(:account) { create(:prime_account, network: network, user: user) }

  describe 'prime accounts' do
    it 'belongs to network' do
      expect(Prime::Account.reflect_on_association(:network).macro).to eq(:belongs_to)
      expect(account.network).to eq(network)
    end

    it 'belongs to user' do
      expect(Prime::Account.reflect_on_association(:user).macro).to eq(:belongs_to)
      expect(account.user).to eq(user)
    end
  end
end
