class Livepeer::Adapters::DelegatorAdapter < Livepeer::Adapters::BaseAdapter
  attribute :transcoder_address

  def transcoder_address
    data.delegate.id
  end
end
