module Celo
  class AccountDetails < Common::Resource
    field :name
    field :metadata_url
    collection :transfers, type: Celo::Transfer
    collection :transactions, type: Celo::Transaction

    def self.failed(address)
      new(name: address)
    end
  end
end
