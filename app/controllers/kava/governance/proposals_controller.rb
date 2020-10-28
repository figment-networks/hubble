class Kava::Governance::ProposalsController < Cosmoslike::Governance::ProposalsController
  layout 'redesign/application'

  def self.controller_path
    'cosmoslike/redesign/governance/proposals'
  end
end
