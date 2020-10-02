module Polkadot
  class Account < Common::Resource
    attr_accessor :nonce,
                  :referendum_count,
                  :free,
                  :reserved,
                  :misc_frozen,
                  :fee_frozen

    def initialize(attributes = {})
      super(attributes)

      # shall we use `dry-struct` gem instead?
      @free = free.to_i
      @reserved = reserved.to_i
      @misc_frozen = misc_frozen.to_i
      @fee_frozen = fee_frozen.to_i
    end

    def total
      free + reserved
    end
  end
end
