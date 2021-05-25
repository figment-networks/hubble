require 'rails_helper'

describe Mina::AccountBalancesController do
  describe 'GET #show' do
    subject { get :show, params: params }

    let(:params) do
      { network: chain.network_name.downcase, chain_id: chain.slug,
        id: 'B62qjrNteTPA2h225Zos7Xr1z8SXBf9GdtTh8NSHZiT24a6YpH2zL91', format: :json }
    end
    let(:chain) { create(:mina_chain, graphql_api_url: 'http://localhost:8082') }

    it 'returns a json response', :vcr do
      subject
      result = JSON.parse(response.body)
      expect(result).to include('nonce')
      expect(result).to include('balance')
    end
  end
end
