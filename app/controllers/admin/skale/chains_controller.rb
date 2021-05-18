class Admin::Skale::ChainsController < Admin::BaseChainsController
  def self.local_prefixes
    ['admin/skale/chains']
  end

  private

  def chain_class
    ::Skale::Chain
  end
end
