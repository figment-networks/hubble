class Avalanche::ValidatorSummary < Common::Resource
  field :total_delegated, type: :integer
  field :time, type: :timestamp, default: 0
end
