class Admin::Avalanche::ChainsController < Admin::BaseChainsController
  def self.local_prefixes
    ['admin/avalanche/chains']
  end

  private

  def chain_class
    ::Avalanche::Chain
  end
end
