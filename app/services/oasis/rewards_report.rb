module Oasis
  class RewardsReport < Common::Resource
    field :time_bucket, type: :timestamp
    field :start_height
    field :address
    field :escrow_address
    field :total_rewards, type: :integer
    field :total_commission, type: :integer
    field :total_slashed, type: :integer

    def self.failed(id)
      new(address: id)
    end
  end
end
