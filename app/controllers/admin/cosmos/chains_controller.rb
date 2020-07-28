class Admin::Cosmos::ChainsController < Admin::Cosmoslike::ChainsController
  prepend_before_action -> { @namespace = ::Cosmos }
end
