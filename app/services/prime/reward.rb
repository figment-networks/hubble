module Prime
  class Reward < Common::Resource
    field :time, type: :timestamp
    field :amount, type: :float
    field :validator_address
    field :token_factor, type: :integer
    field :token_display
    field :account, type: Prime::Account

    def initialize(attr, account, token_factor: nil, token_display: nil)
      super(attr)
      @token_factor = token_factor || account.network.primary.reward_token_factor
      @token_display = token_display || account.network.primary.reward_token_display
      @account = account
    end
  end
end
