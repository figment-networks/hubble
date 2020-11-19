class Admin::Celo::ChainsController < Admin::BaseChainsController
  def self.local_prefixes
    ['admin/indexer/chains']
  end

  private

  def chain_class
    ::Celo::Chain
  end
end
