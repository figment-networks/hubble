class Polkadot::ValidatorSummary < Common::Resource
  attr_accessor :total_stake_avg,
                :uptime_avg,
                :time_bucket

  def initialize(attributes = {})
    super(attributes)
    @time_bucket = Time.zone.parse(time_bucket)
    @total_stake_avg = total_stake_avg.to_i
  end

  def total_stake
    total_stake_avg
  end
end
