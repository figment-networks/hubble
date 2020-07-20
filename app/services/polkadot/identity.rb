module Polkadot
  class Identity < Common::Resource
    attr_accessor :deposit,
                  :display_name,
                  :legal_name,
                  :web_name,
                  :riot_name,
                  :email_name,
                  :twitter_name,
                  :image
  end
end
