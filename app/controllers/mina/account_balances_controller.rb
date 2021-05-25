class Mina::AccountBalancesController < Mina::BaseController
  def show
    response = RestClient.post(
      "#{@chain.graphql_api_url}/graphql",
      { query: account_query,
        variables: { publicKey: params[:id] } }.to_json,
      { 'Content-Type' => 'application/json' }
    )

    response_json = JSON.parse(response.body)

    result = if response_json['errors']
               { error: response_json['errors'].first['message'] }
             else
               {
                 nonce: response_json['data']['account']['nonce'],
                 balance: response_json['data']['account']['balance']['total']
               }
             end
    render json: result
  end

  private

  def account_query
    <<-GRAPHQL
    query($publicKey: PublicKey) {
      account(publicKey: $publicKey) {
        nonce
        balance {
          total
        }
      }
    }
    GRAPHQL
  end
end
