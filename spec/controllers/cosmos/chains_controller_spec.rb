require 'rails_helper'

RSpec.describe Cosmos::ChainsController do
  describe "GET #show" do
    subject { create(:cosmos_chain) }

    context "when chain is present" do
      it "does not return 404" do
        get :show, params: { network: subject.network_name.downcase, id: subject.slug }
        expect(response).to_not have_http_status(404)
      end
    end

    context "when chain is not present" do
      it "returns 404 status" do
        get :show, params: { network: subject.network_name.downcase, id: "absent-id" }
        expect(response).to have_http_status(404)
      end
    end
  end
end
