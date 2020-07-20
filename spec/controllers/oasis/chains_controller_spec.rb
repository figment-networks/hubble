require 'rails_helper'

RSpec.describe Oasis::ChainsController do
  describe "GET #show" do
    subject { create(:oasis_chain) }

    context "when chain is present" do
      it "does not return 404" do
        get :show, params: { network: subject.network_name.downcase, id: subject.slug }
        expect(response).to_not have_http_status(404)
      end
    end

    context "when chain is not present" do
      before(:each) { get :show, params: { network: subject.network_name.downcase, id: "absent-id" } }
      it "returns 404 status" do      
        expect(response).to have_http_status(404)
      end
    end
  end
end
