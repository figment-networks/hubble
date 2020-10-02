module Near
  class ValidatorEpoch < Common::Resource
    field :epoch
    field :last_height
    field :last_time, type: :timestamp
    field :expected_blocks
    field :produced_blocks
    field :efficiency
  end
end
