class Admin::Polkadot::ChainsController < Admin::BaseChainsController
  def self.local_prefixes
    ['admin/indexer/chains']
  end

  private

  def chain_class
    ::Polkadot::Chain
  end
end
