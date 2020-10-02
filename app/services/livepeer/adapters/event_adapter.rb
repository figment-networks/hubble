class Livepeer::Adapters::EventAdapter < Livepeer::Adapters::BaseAdapter
  attribute :transaction_hash
  attribute :orchestrator_address
  attribute :timestamp

  def orchestrator_address
    data.delegate.id
  end

  def timestamp
    convert_timestamp(data.timestamp)
  end
end
