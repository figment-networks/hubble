class Cosmos::BlocksController < Cosmoslike::BlocksController
  layout 'redesign/application'

  def self.controller_path
    'cosmoslike/redesign/blocks'
  end
end
