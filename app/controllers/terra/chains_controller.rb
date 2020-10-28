class Terra::ChainsController < Cosmoslike::ChainsController
  layout 'redesign/application'

  def self.controller_path
    'cosmoslike/redesign/chains'
  end
end
