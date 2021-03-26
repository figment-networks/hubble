module Prime
  class Reward::Oasis < Prime::Reward
    field :time, type: :timestamp
    field :amount, type: :integer

    def initialize(attr, account, token_factor: nil, token_display: nil)
      super(attr, account, token_factor: token_factor, token_display: token_display)
      @time = Time.zone.parse(attr['time_bucket'])
      @amount = attr['total_rewards']
      @validator_address = attr['escrow_address']
    end
  end
end
