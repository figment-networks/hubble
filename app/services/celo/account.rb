module Celo
  class Account < Common::Resource
    field :gold_balance, type: :integer
    field :total_locked_gold, type: :integer
    field :total_nonvoting_locked_gold, type: :integer
    field :stable_token_balance, type: :integer

    def self.failed(_address)
      new
    end
  end
end
