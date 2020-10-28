class Iris::ValidatorsController < Cosmoslike::ValidatorsController
  layout 'redesign/application'

  def self.controller_path
    'cosmoslike/redesign/validators'
  end
end
