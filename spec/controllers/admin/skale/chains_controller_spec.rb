require 'rails_helper'

RSpec.describe Admin::Skale::ChainsController do
  let!(:chain) { create(:skale_chain) }
  let!(:admin) { create(:admin) }

  before do
    session[:admin_id] = admin.id
  end

  describe 'GET #show', :vcr do
    before { get :show, params: { id: chain.slug } }

    it 'responds with 200 status' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the :show view' do
      expect(response).to render_template(:show)
    end

    it "doesn't show error", :vcr do
      expect(flash[:error]).to be_nil
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:params) { attributes_for(:skale_chain, slug: 'skaleslug2') }

      it 'saves the new chain' do
        expect do
          post :create, params: { skale_chain: params }
        end .to change(chain.class, :count).by(1)
      end

      it 'responds with 302 status' do
        post :create, params: { skale_chain: params }
        expect(response).to have_http_status(:found)
      end

      it 'redirects to admin_root_path' do
        post :create, params: { skale_chain: params }
        expect(response).to redirect_to(admin_root_path)
      end

      it 'flashes success notice' do
        post :create, params: { skale_chain: params }
        expect(flash[:notice]).to match('Chain created successfully')
      end
    end

    context 'with invalid params' do
      let(:params) { attributes_for(:skale_chain, slug: chain.slug) }

      it 'does not save the new chain' do
        expect do
          post :create, params: { skale_chain: params }
        end .to change(chain.class, :count).by(0)
      end

      it 'responds with 200 status' do
        post :create, params: { skale_chain: params }
        expect(response).to have_http_status(:ok)
      end

      it 're-renders :new' do
        post :create, params: { skale_chain: params }
        expect(response).to render_template(:new)
      end

      it 'flashes error' do
        post :create, params: { skale_chain: params }
        expect(flash[:error]).not_to be_nil
      end
    end
  end

  describe 'PUT #update' do
    context 'with no errors' do
      let(:new_params) { { name: 'new name' } }

      before { put :update, params: { id: chain.slug, skale_chain: new_params } }

      it 'updates the chain' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to admin_root_path' do
        expect(response).to redirect_to(admin_root_path)
      end

      it 'flashes success notice' do
        expect(flash[:notice]).to match('Chain info has been updated!')
      end
    end

    context 'with errors' do
      let(:wrong_new_params) { { name: '' } }

      before { put :update, params: { id: chain.slug, skale_chain: wrong_new_params } }

      it 'does not udpate the chain' do
        expect(response).to have_http_status(:ok)
      end

      it 're-renders :edit' do
        expect(response).to render_template(:edit)
      end

      it 'flashes errors' do
        expect(flash[:error]).not_to be_nil
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the chain' do
      expect { delete :destroy, params: { id: chain.slug } }.to change(chain.class, :count).by(-1)
    end

    it 'responds with 302 status' do
      delete :destroy, params: { id: chain.slug }
      expect(response).to have_http_status(:found)
    end

    it 'redirects to admin_root_path' do
      delete :destroy, params: { id: chain.slug }
      expect(response).to redirect_to(admin_root_path)
    end

    it 'flashes success notice' do
      delete :destroy, params: { id: chain.slug }
      expect(flash[:notice]).to match('Chain has been deleted!')
    end
  end
end
