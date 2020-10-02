class Livepeer::Adapters::MissedRewardCallAdapter < Livepeer::Adapters::BaseAdapter
  attribute :orchestrator_address
  attribute :timestamp

  def orchestrator_address
    data.delegate.id
  end

  def timestamp
    convert_timestamp(data.round.timestamp)
  end
end
