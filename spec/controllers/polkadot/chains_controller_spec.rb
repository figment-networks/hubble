require 'rails_helper'

describe Polkadot::ChainsController do
  describe 'GET #search' do
    before { get :search, params: params }

    let(:params) { { network: chain.network_name.downcase, id: chain.slug, query: 'abc' } }
    let(:chain) { create(:polkadot_chain) }

    it 'redirects to chain path' do
      expect(response).to redirect_to(polkadot_chain_path(chain))
    end
  end
end
