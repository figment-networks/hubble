module Oasis
  class Transaction < Common::Resource
    attr_accessor :public_key,
                  :hash,
                  :nonce,
                  :fee,
                  :gas_limit,
                  :gas_price,
                  :method

  end
end
