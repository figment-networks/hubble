class Terra::AccountsController < Cosmoslike::AccountsController
  layout 'redesign/application'

  def self.controller_path
    'cosmoslike/redesign/accounts'
  end
end
