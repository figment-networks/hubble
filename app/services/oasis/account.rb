module Oasis
  class Account < Common::Resource
    field :address
    field :escrow_active_balance
    field :escrow_debonding_balance
    field :delegations
    field :general_balance

    alias_attribute :liquid_balance, :general_balance

    def initialize(attr, address)
      super(attr)
      @address = address
      @delegations = []
    end

    def self.failed(address)
      new({}, 'address' => address)
    end

    def total_balance
      delegations.sum(&:shares) + general_balance
    end

    def bonded_balance
      delegations.select { |d| d.status == 'bonded' }.sum(&:shares)
    end

    def debonding_balance
      delegations.select { |d| d.status == 'debonding' }.sum(&:shares)
    end
  end
end
