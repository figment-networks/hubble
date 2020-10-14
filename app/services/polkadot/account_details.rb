module Polkadot
  class AccountDetails < Common::Resource
    field :address
    field :deposit, type: :integer
    field :display_name
    field :legal_name
    field :web_name
    field :riot_name
    field :email_name
    field :twitter_name
    field :image
    field :transfers
    field :deposits
    field :bonded
    field :unbonded
    field :withdrawn
    field :delegations

    def display_name
      @display_name.presence || address
    end

    def self.failed(address)
      new('display_name' => address)
    end
  end
end
