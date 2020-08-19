class Polkadot::ValidatorSummary < Common::Resource
  attr_accessor :total_stake_avg,
                :time_bucket,
                :validators_count

  def initialize(attrs = {})
    super(attrs)
    @time_bucket = Time.zone.parse(time_bucket)
    @total_stake_avg = total_stake_avg.to_i
    @validators_count = validators_count.to_i
  end

  def total_stake
    total_stake_avg * validators_count
  end
end
