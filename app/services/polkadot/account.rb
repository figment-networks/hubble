module Polkadot
  class Account < Common::Resource
    field :nonce, type: :integer
    field :referendum_count, type: :integer
    field :free, type: :integer
    field :reserved, type: :integer
    field :misc_frozen, type: :integer
    field :fee_frozen, type: :integer

    def total
      free + reserved
    end
  end
end
