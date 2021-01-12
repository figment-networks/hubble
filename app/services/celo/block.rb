module Celo
  class Block < Common::Resource
    field :height
    field :time, type: :unix_timestamp
    field :hash
    field :gas_used, type: :integer
  end
end
