require 'rails_helper'

RSpec.describe Cosmos::DashboardController do
  let(:chain) { create(:cosmos_chain) }
  let(:user) { build(:user) }

  before { allow(controller).to receive(:current_user).and_return(user) }

  describe 'GET #index' do
    subject { get :index, params: { chain_id: chain.slug, network: 'cosmos' } }

    it { is_expected.to have_http_status(:ok) }
  end
end
