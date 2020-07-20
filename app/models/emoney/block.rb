class Emoney::Block < ApplicationRecord
  include Cosmoslike::Blocklike

  protected

  def self.process_voting_power( voting_power, chain )
    # emoney blocks report voting power as NGM
    # while it should be ungm. so, convert
    (voting_power * (10 ** -chain.token_map[chain.primary_token]['factor'])).to_i
  end
end
