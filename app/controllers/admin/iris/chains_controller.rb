class Admin::Iris::ChainsController < Admin::Cosmoslike::ChainsController
  prepend_before_action -> { @namespace = ::Iris }
end
