class Cosmoslike::NetworkDataFetcher
  class FetchError < StandardError; end

  attr_reader :chain, :syncer

  def initialize(chain, syncer)
    @chain = chain
    @syncer = syncer
  end

  def daily_rewards
    rewards_per_block = ( total_supply * 10**-(token_factor) ) *
        (reported_inflation / reported_blocks_per_year) * 0.98

    rewards_per_block * 1.day.seconds / average_block_time
  end

  def rewards_rate
    actual_blocks_per_year = 1.year.seconds / average_block_time

    (total_supply * actual_blocks_per_year * 0.98) / reported_blocks_per_year *
        reported_inflation / staked_amount * 100
  end

  def staking_participation
    staked_amount / total_supply * 100
  end

  private

  def token_factor
    chain.namespace::Chain::DEFAULT_TOKEN_FACTOR
  end

  def average_block_time
    chain.average_block_time.to_f
  end

  def staked_amount
    chain.staked_amount.to_f
  end

  def lcd_data(data, response)
    if response =~ /[A-Za-z]+/ || response.nil?
      raise FetchError.new("#{data} not found for #{chain.ext_id}")
    else
      response.to_f
    end
  end

  def total_supply
    total_supply = syncer.get_total_supply
    lcd_data("Total supply", total_supply)
  end

  def reported_inflation
    reported_inflation = syncer.get_reported_inflation
    lcd_data("Reported inflation", reported_inflation)
  end

  def reported_blocks_per_year
    reported_blocks_per_year = syncer.get_reported_blocks_per_year
    lcd_data("Reported blocks per year", reported_blocks_per_year)
  end
end
