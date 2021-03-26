require 'rails_helper'

RSpec.describe Prime::Admin::ChainsController do
  let!(:network) { create(:prime_network) }
  let!(:chain) { create(:prime_chain, network: network) }
  let!(:admin) { create(:admin) }

  before do
    session[:admin_id] = admin.id
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:params) { attributes_for(:prime_chain).merge(prime_network_id: network.id) }

      it 'saves the new chain' do
        expect do
          post :create, params: { prime_chain: params, network_id: network.name }
        end .to change(chain.class, :count).by(1)
      end

      it 'responds with 302 status' do
        post :create, params: { prime_chain: params, network_id: network.name }
        expect(response).to have_http_status(:found)
      end

      it 'redirects to prime_admin_root_path' do
        post :create, params: { prime_chain: params, network_id: network.name }
        expect(response).to redirect_to(prime_admin_root_path)
      end
    end

    context 'with invalid params' do
      let(:params) { { foo: 'bar' } }

      it 'does not save the new chain' do
        expect do
          post :create, params: { prime_chain: params, network_id: network.name }
        end .to change(chain.class, :count).by(0)
      end

      it 'does not respond with 302 status' do
        post :create, params: { prime_chain: params, network_id: network.name }
        expect(response).not_to have_http_status(:found)
      end
    end
  end

  describe 'PUT #update' do
    let(:new_params) { { name: 'new name' } }

    before { put :update, params: { id: chain.slug, network_id: chain.network.name, prime_chains_polkadot: new_params } }

    it 'updates the chain' do
      expect(response).to have_http_status(:found)
    end

    it 'redirects to prime_admin_root_path' do
      expect(response).to redirect_to(prime_admin_root_path)
    end

    it 'flashes success notice' do
      expect(flash[:notice]).to match('Chain info has been updated!')
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the chain' do
      expect { delete :destroy, params: { id: chain.slug, network_id: chain.network.name } }.to change(chain.class, :count).by(-1)
    end

    it 'responds with 302 status' do
      delete :destroy, params: { id: chain.slug, network_id: chain.network.name }
      expect(response).to have_http_status(:found)
    end

    it 'redirects to prime_admin_root_path' do
      delete :destroy, params: { id: chain.slug, network_id: chain.network.name }
      expect(response).to redirect_to(prime_admin_root_path)
    end

    it 'flashes success notice' do
      delete :destroy, params: { id: chain.slug, network_id: chain.network.name }
      expect(flash[:notice]).to match('Chain has been deleted!')
    end
  end
end
