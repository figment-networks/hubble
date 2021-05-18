require 'rails_helper'

describe Mina::TransactionBroadcastsController do
  describe 'POST #create' do
    subject { post :create, params: params }

    let(:params) do
      {
        network: chain.network_name.downcase, chain_id: chain.slug,
        account_address: 'B62qjrNteTPA2h225Zos7Xr1z8SXBf9GdtTh8NSHZiT24a6YpH2zL91',
        validator: 'B62qoERu6rA6UUxk6yNYN9CfrvXwNB7tBF94TQucZNRkabQNiDJoMiR',
        fee: 1000000, memo: 'https://hubble.figment.io', nonce: 7,
        signature: '39603762bc8aa733734fef3eeb7e3911c94ce40fa0329c4108359be43d35bc620be2bd56b75985a176e5ed14e4b2156bd227bcb5ae2036220799be04ea5f6ad2',
        format: :json
      }
    end
    let(:chain) { create(:mina_chain, graphql_api_url: 'http://localhost:8082') }

    it 'returns a json response', :vcr do
      subject
      result = JSON.parse(response.body)
      expect(result).to include('transaction_hash')
    end
  end
end
