require 'rails_helper'

RSpec.describe Admin::Oasis::ChainsController do
  let!(:chain) { create(:oasis_chain) }
  let!(:admin) { create(:admin) }

  before do
    session[:admin_id] = admin.id 
  end
  
  describe "GET #show" do
    before(:each) {get :show, params: { id: chain.slug }}

    it "responds with 200 status" do
      expect(response).to have_http_status(:ok)
    end

    it "renders the :show view" do
      expect(response).to render_template(:show)
    end

    it "doesn't show error" do
      expect(flash[:error]).to be_nil
    end
  end

  describe "POST #create" do
    context "with valid params" do
      let(:params) { attributes_for(:oasis_chain) }

      it "saves the new chain" do
        expect{ post :create, params: { oasis_chain: params } }.to change(chain.class, :count).by(1)
      end

      it "responds with 302 status" do
        post :create, params: { oasis_chain: params }
        expect(response).to have_http_status(:found)
      end

      it "redirects to admin_root_path" do
        post :create, params: { oasis_chain: params }
        expect(response).to redirect_to(admin_root_path)
      end
    end

    context "with invalid params" do
      let(:params) { { foo: 'bar' } }

      it "does not save the new chain" do
        expect{ post :create, params: { oasis_chain: params } }.to change(chain.class, :count).by(0)
      end

      it "does not respond with 302 status" do
        post :create, params: { oasis_chain: params }
        expect(response).to_not have_http_status(:found)
      end
    end
  end

  describe "PUT #update" do 
    let(:new_params) { { name: "new name" } }
    before(:each) { put :update, params: { id: chain.slug, oasis_chain: new_params } }

    it "updates the chain" do 
      expect(response).to have_http_status(:found)
    end

    it "redirects to admin_root_path" do
      expect(response).to redirect_to(admin_root_path)
    end

    it "flashes success notice" do
      expect(flash[:notice]).to match("Chain info has been updated!")
    end
  end

  describe "DELETE #destroy" do

    it "destroys the chain" do
      expect{ delete :destroy, params: { id: chain.slug } }.to change(chain.class, :count).by(-1)
    end

    it "responds with 302 status" do
      delete :destroy, params: { id: chain.slug }
      expect(response).to have_http_status(:found)
    end 

    it "redirects to admin_root_path" do
      delete :destroy, params: { id: chain.slug }
      expect(response).to redirect_to(admin_root_path)
    end

    it "flashes success notice" do
      delete :destroy, params: { id: chain.slug }
      expect(flash[:notice]).to match("Chain has been deleted!")
    end
  end
end
