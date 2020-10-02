module Oasis
  class BlockTime < Common::Resource
    field :start_height, type: :integer
    field :end_height, type: :integer
    field :start_time, type: :timestamp
    field :end_time, type: :timestamp
    field :count, type: :integer
    field :diff, type: :integer
    field :avg, type: :float
  end
end
