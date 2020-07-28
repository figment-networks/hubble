class Admin::Emoney::ChainsController < Admin::Cosmoslike::ChainsController
  prepend_before_action -> { @namespace = ::Emoney }
end
