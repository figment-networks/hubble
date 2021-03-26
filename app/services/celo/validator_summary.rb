class Celo::ValidatorSummary < Common::Resource
  field :signed_avg, type: :float, default: 0
  field :score_avg, type: :integer, default: 0
  field :time_bucket, type: :timestamp

  def total
    score_avg
  end

  def uptime_avg
    signed_avg
  end
end
