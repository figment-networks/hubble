class Prime::DailyRewardsReport
  FIELDS = %i[
    date
    address
    reward
    token_price
    usd_equivalent
    validator
  ].freeze

  def initialize(user, network)
    @user = user
    @network = network
  end

  def to_csv
    data = rewards_to_rows(user_network_accounts)
    Common::CsvExporter.new(data, FIELDS).call
  end

  private

  def user_network_accounts
    Prime::Account.for_user(@user.id).for_network(@network.id)
  end

  def rewards_to_rows(accounts)
    rows = []
    accounts.each do |account|
      token_hash = account.network.daily_price_series_hash
      factor = account.network.primary.reward_token_factor
      account.rewards.each do |reward|
        factored_reward = reward.amount.to_f / (10 ** factor)
        rows << {
          date: reward.time,
          address: account.address,
          reward: factored_reward,
          token_price: token_price(reward.time, token_hash),
          usd_equivalent: factored_reward * token_price(reward.time, token_hash),
          validator: reward.validator_address
        }
      end
    end
    rows.sort! { |a, b| b[:date] <=> a[:date] }
  end

  def format_timestamp(stamp)
    Time.strptime(stamp.to_s, '%s').to_s.split(' ').first
  end

  def token_price(stamp, token_hash)
    token_hash[format_timestamp(stamp.to_i)] || 0
  end
end
