require 'rails_helper'

RSpec.describe Prime::AccountsController do
  let!(:user) { create(:user, prime: true) }
  let!(:network) { create(:prime_network) }
  let!(:chain) do
    create(:prime_chain,
           name: 'Polkadot',
           slug: 'polkadot',
           network: network)
  end
  let!(:admin) { create(:admin) }
  let(:account) { create(:prime_account, network: network, user: user, address: '138QdRbUTB9eNY94Q4Mj5r39FkgMiyHCAy8UFMNA5gvtrfSB') }
  let!(:existing_account) { create(:prime_account, network: network, user: user, address: '1WG3jyNqniQMRZGQUc7QD2kVLT8hkRPGMSqAb5XYQM1UDxN') }

  before do
    session[:admin_id] = admin.id
  end

  describe 'POST #create' do
    context 'with valid params', :vcr do
      before { allow(controller).to receive(:current_user).and_return(user) }

      let(:params) { attributes_for(:prime_account).merge(prime_network_id: network.id, user_id: user.id, address: '138QdRbUTB9eNY94Q4Mj5r39FkgMiyHCAy8UFMNA5gvtrfSB') }

      it 'saves the new account' do
        expect do
          post :create, params: { prime_account: params, network_id: network.id, user_id: user.id }
        end.to change(Prime::Account, :count).by(1)
      end

      it 'responds with 302 status' do
        post :create, params: { prime_account: params, network_id: network.id, user_id: user.id }
        expect(response).to have_http_status(:found)
      end

      it 'redirects to prime_root_path' do
        post :create, params: { prime_account: params, network_id: network.id, user_id: user.id }
        expect(response).to redirect_to(prime_root_path)
      end
    end

    context 'with invalid params' do
      before { allow(controller).to receive(:current_user).and_return(user) }

      let(:params) { { foo: 'bar' } }

      it 'does not save the new chain' do
        expect do
          post :create, params: { prime_account: params, network_id: network.id, user_id: user.id }
        end.to change(Prime::Account, :count).by(0)
      end
    end

    context 'with existing address', :vcr do
      before { allow(controller).to receive(:current_user).and_return(user) }

      let(:params) { attributes_for(:prime_account).merge(prime_network_id: existing_account.prime_network_id, user_id: existing_account.user_id) }

      it 'does not save the new chain' do
        params[:address] = existing_account.address

        # pre_count = Prime::Account.count
        expect do
          post :create, params: { prime_account: params, network_id: existing_account.prime_network_id, user_id: existing_account.user_id }
        end.to change(Prime::Account, :count).by(0)
        expect(flash[:error]).to match('This address is already in your portfolio.')
      end
    end
  end

  describe 'DELETE #destroy' do
    before { allow(controller).to receive(:current_user).and_return(user) }

    it 'destroys the chain' do
      expect { delete :destroy, params: { id: account.id, network_id: account.network.id } }.to change(account.class, :count).by(-1)
    end

    it 'responds with 302 status' do
      delete :destroy, params: { id: account.id }
      expect(response).to have_http_status(:found)
    end

    it 'redirects to prime_admin_root_path' do
      delete :destroy, params: { id: account.id, network_id: account.network.id }
      expect(response).to redirect_to(prime_accounts_path)
    end

    it 'flashes success notice' do
      delete :destroy, params: { id: account.id, network_id: account.network.id }
      expect(flash[:success]).to match('Address deleted from your portfolio.')
    end
  end
end
