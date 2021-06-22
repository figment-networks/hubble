module Prime
  class Reward::Terra < Prime::Reward
    field :time, type: :timestamp
    field :amount, type: :integer

    def initialize(attr, account, time, validator, token_factor: nil, currency: nil)
      super(attr, account, token_factor: token_factor, token_display: currency)
      @time = Time.zone.parse(time.to_s)
      @amount = attr['numeric'] / (10 ** attr['exp'])
      @validator_address = validator
      @token_display = currency.slice(1..).upcase
    end
  end
end
