class Admin::Terra::ChainsController < Admin::Cosmoslike::ChainsController
  prepend_before_action -> { @namespace = ::Terra }
end
