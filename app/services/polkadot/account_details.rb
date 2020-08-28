module Polkadot
  class AccountDetails < Common::Resource
    attr_accessor :deposit,
                  :display_name,
                  :legal_name,
                  :web_name,
                  :riot_name,
                  :email_name,
                  :twitter_name,
                  :image,
                  :transfers,
                  :deposits,
                  :bonded,
                  :unbonded,
                  :withdrawn

    def self.failed(address)
      new('display_name' => address)
    end
  end
end
