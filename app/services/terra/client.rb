module Terra
  class Client < Common::IndexerClient
    DEFAULT_TIMEOUT = 10

    def transaction_search_request(body)
      tx_list = post(body: body, content_type: 'application/json') || []

      tx_list.map do |transaction|
        Terra::TransactionSearchResult.new(transaction)
      end
    end
  end
end
