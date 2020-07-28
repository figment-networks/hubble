require 'rails_helper'

RSpec.describe Admin::Tezos::ChainsController do
  let!(:chain) { create(:tezos_chain) }
  let!(:admin) { create(:admin) }

  before do
    session[:admin_id] = admin.id 
  end
  
  describe "POST #create" do
    context "with valid params" do
      let(:params) { attributes_for(:tezos_chain) }

      it "saves the new chain" do
        expect{ post :create, params: { tezos_chain: params } }.to change(chain.class, :count).by(1)
      end

      it "responds with 302 status" do
        post :create, params: { tezos_chain: params }
        expect(response).to have_http_status(:found)
      end

      it "redirects to admin_root_path" do
        post :create, params: { tezos_chain: params }
        expect(response).to redirect_to(admin_root_path)
      end

      it "flashes success notice" do
        post :create, params: { tezos_chain: params }
        expect(flash[:notice]).to match("Chain created successfully")
      end
    end

    context "with invalid params" do
      let(:params) { { } }

      it "does not save the new chain" do
        expect{ post :create, params: { tezos_chain: params } }.to change(chain.class, :count).by(0)
      end

      it "does not respond with 302 status" do
        post :create, params: { tezos_chain: params }
        expect(response).to_not have_http_status(:found)
      end
    end
  end

  describe "PUT #update" do 
    context "with no errors" do
      let(:new_params) { { name: "new name" } }
      before(:each) { put :update, params: { id: chain.slug, tezos_chain: new_params } }

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

    context "with errors" do 
      let(:wrong_new_params) { { } }
      before(:each) { put :update, params: { id: chain.slug, tezos_chain: wrong_new_params } }

      it "does not udpate the chain" do 
        expect(response).to_not have_http_status(:found)
      end
    end
  end

  describe "DELETE #destroy" do

    it "deletes the chain" do
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
