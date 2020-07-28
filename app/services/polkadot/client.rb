module Polkadot
  class Client < Common::IndexerClient
    def transaction(transaction_id)
      Polkadot::Transaction.new(get("/transactions/#{transaction_id}"))
    end

    def account(address)
      Polkadot::Account.new(get('/account/by_height', params: {address: address}))
    end

    def identity(address)
      Polkadot::Identity.new(get('/account/identity', params: {address: address}))
    end
  end
end
