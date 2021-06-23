module Terra
  class Client < Common::IndexerClient
    DEFAULT_TIMEOUT = 30
    DEFAULT_REWARDS_REQUEST_LENGTH = 90.days

    def transaction_search_request(body)
      tx_list = post(body: body, content_type: 'application/json') || []

      tx_list.map do |transaction|
        Terra::TransactionSearchResult.new(transaction)
      end
    end

    def account(address)
      Terra::AccountDecorator.new(Terra::Chain.primary, address)
    end

    def prime_rewards(account)
      Rails.cache.fetch([self.class.name, 'rewards', account.address].join('-'), expires_in: MEDIUM_EXPIRY_TIME) do
        token_factor = account.network.primary.reward_token_factor
        token_display = account.network.primary.reward_token_display
        start_time = (Time.now.utc - DEFAULT_REWARDS_REQUEST_LENGTH).iso8601
        end_time = Time.now.utc.iso8601

        Prime::Chains::Terra.active.order(:genesis_block_time).reverse.map do |chain|
          next unless chain.genesis_block_time < end_time
          next unless chain.final_block_time.nil? || (chain.final_block_time > start_time)

          rewards = get('/rewards', network: 'terra', chain_id: chain.slug, account: account.address, start_time: start_time, end_time: end_time).map do |period|
            period['rewards'].map do |reward|
              Prime::Reward::Terra.new(reward, account, period['time'], period['validator'], token_factor: token_factor, currency: reward['currency'])
            end.flatten
          end.flatten
        end.flatten
      end
    end
  end
end
