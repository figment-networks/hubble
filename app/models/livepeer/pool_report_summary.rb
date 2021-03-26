class Livepeer::PoolReportSummary
  DEFAULT_VALUE = BigDecimal(0)

  FIELDS = %i[
    orchestrator_address
    total_stake
    reward_tokens
  ].freeze

  def initialize(chain, params)
    @chain = chain
    @params = params
  end

  def data
    orchestrator_addresses.map do |orchestrator_address|
      FIELDS.each_with_object({}) do |field, hash|
        hash[field] = send(field)[orchestrator_address] || DEFAULT_VALUE
      end
    end
  end

  def to_csv
    Common::CsvExporter.new(data, FIELDS).call
  end

  private

  attr_reader :chain
  attr_reader :params

  def orchestrator_addresses
    chain.pools.pluck(:orchestrator_address).uniq.sort
  end

  def orchestrator_address
    ->(address) { address }
  end

  def total_stake
    @total_stake ||= group_by_orchestrator(pool_stakes, :total_stake)
  end

  def reward_tokens
    @reward_tokens ||= group_by_orchestrator(pool_rewards, :reward_tokens)
  end

  def group_by_orchestrator(records, field_name)
    records.each_with_object({}) do |record, hash|
      hash[record.orchestrator_address] = record[field_name]
    end
  end

  def pool_stakes
    @pool_stakes ||= Livepeer::Queries::PoolStakesQuery.new(chain, params).call
  end

  def pool_rewards
    @pool_rewards ||= Livepeer::Queries::PoolRewardsQuery.new(chain, params).call
  end
end
