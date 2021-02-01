class Cosmos::Governance::MainController < Cosmoslike::Governance::MainController
  layout 'redesign/application'

  def self.controller_path
    'cosmoslike/redesign/governance/main'
  end
end
