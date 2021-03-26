class Livepeer::PoolReport < Livepeer::Report
  FIELDS = %i[
    round_number
    orchestrator_address
    total_stake
    reward_tokens
  ].freeze

  private

  def report_summary
    Livepeer::PoolReportSummary.new(chain, params)
  end

  def details
    round_numbers.product(orchestrator_addresses)
  end

  def orchestrator_addresses
    chain.pools.pluck(:orchestrator_address).uniq.sort
  end

  def total_stake
    @total_stake ||= group_by_round_and_orchestrator(pool_stakes, :total_stake)
  end

  def reward_tokens
    @reward_tokens ||= group_by_round_and_orchestrator(pool_rewards, :reward_tokens)
  end

  def group_by_round_and_orchestrator(records, field_name)
    records.each_with_object({}) do |record, hash|
      key = [record.round_number, record.orchestrator_address]
      hash[key] = record[field_name]
    end
  end

  def pool_stakes
    @pool_stakes ||= Livepeer::Queries::PoolStakesPerRoundQuery.new(chain, params).call
  end

  def pool_rewards
    @pool_rewards ||= Livepeer::Queries::PoolRewardsPerRoundQuery.new(chain, params).call
  end
end
