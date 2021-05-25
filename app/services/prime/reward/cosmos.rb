module Prime
  class Reward::Cosmos < Prime::Reward
    field :time, type: :timestamp
    field :amount, type: :integer

    def initialize(attr, account, token_factor: nil, token_display: nil)
      super(attr, account, token_factor: token_factor, token_display: token_display)
      @time = Time.zone.parse(attr['time'].to_s)
      @amount = attr['rewards'].first['numeric'] / (10 ** attr['rewards'].first['exp'])
      @validator_address = attr['validator']
    end
  end
end
