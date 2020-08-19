require 'rails_helper'

RSpec.describe Oasis::ChainsController do
  describe "GET #show" do
    subject { get :show, params: { network: chain.network_name.downcase, id: id } }
    let(:chain) { create(:oasis_chain) }
    let(:id) { "absent-id" }

    context "when chain is not present" do
      it "returns 404 status" do
        subject
        expect(response).to have_http_status(404)
      end
    end
  end
end
