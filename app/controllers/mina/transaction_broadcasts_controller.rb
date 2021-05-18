class Mina::TransactionBroadcastsController < Mina::BaseController
  skip_before_action :verify_authenticity_token

  def create
    response = RestClient.post(
      "#{@chain.graphql_api_url}/graphql",
      { query: send_delegation_mutation,
        variables: { accountAddress: params[:account_address],
                     validator: params[:validator],
                     fee: params[:fee],
                     memo: params[:memo],
                     nonce: params[:nonce],
                     signature: params[:signature] } }.to_json,
      { 'Content-Type' => 'application/json' }
    )

    response_json = JSON.parse(response.body)

    result = if response_json['errors']
               { error: response_json['errors'].first['message'] }
             else
               { transaction_hash: response_json['data']['sendDelegation']['delegation']['hash'] }
             end
    render json: result
  end

  private

  def send_delegation_mutation
    <<-GRAPHQL
    mutation($fee: UInt64, $validator: PublicKey, $accountAddress: PublicKey, $memo: String, $nonce: UInt32, $signature: String) {
      sendDelegation(
        input: {fee: $fee, to: $validator, from: $accountAddress, memo: $memo, 
          nonce: $nonce, validUntil: "4294967295"}, 
        signature: {rawSignature: $signature}
      ) {
        delegation {
          hash
        }
      }
    }
    GRAPHQL
  end
end
