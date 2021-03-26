module Prime
  class Reward::Polkadot < Prime::Reward
    def initialize(attr, account, token_factor: nil, token_display: nil)
      super(attr, account, token_factor: token_factor, token_display: token_display)
      @validator_address = attr['validator_stash_account']
    end
  end
end
