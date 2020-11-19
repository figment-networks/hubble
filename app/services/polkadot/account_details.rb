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
    field :deposits
    field :bonded
    field :unbonded
    field :withdrawn
    field :delegations
    collection :transfers, type: Polkadot::Transfer

    def initialize(attributes = {})
      super(attributes)
      cache_display_name!(@display_name) if @display_name.present?
    end

    def display_name
      @display_name.presence || read_cached_display_name || address
    end

    def read_cached_display_name
      Rails.cache.read(display_name_cache_key(address))
    end

    def cache_display_name!(name)
      Rails.cache.write(display_name_cache_key(address), name, expires_in: 30.days)
    end

    def self.failed(address, display_name = nil)
      new('address' => address, 'display_name' => display_name)
    end

    private

    def display_name_cache_key(address)
      [self.class.name, 'display_name', address].join('-')
    end
  end
end
