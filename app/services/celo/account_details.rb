module Celo
  class AccountDetails < Common::Resource
    field :name
    field :metadata_url
    collection :operations, type: Celo::Operation
    collection :transactions, type: Celo::Transaction

    def self.failed(address)
      new(name: address)
    end

    def transfers
      operations.select(&:transfer?)
    end
  end
end
