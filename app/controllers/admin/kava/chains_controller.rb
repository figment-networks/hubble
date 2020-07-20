class Admin::Kava::ChainsController < Admin::Cosmoslike::ChainsController
  prepend_before_action -> { @namespace = ::Kava }
end
