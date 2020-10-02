module Oasis
  class Account < Common::Resource
    field :address
    field :escrow_active_balance
    field :escrow_debonding_balance
    field :delegations

    def initialize(attr, address)
      super(attr)
      @address = address
      @delegations = []
    end

    def self.failed(address)
      new({}, 'address' => address)
    end
  end
end
