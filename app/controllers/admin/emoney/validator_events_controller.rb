class Admin::Emoney::ValidatorEventsController < Admin::Common::ValidatorEventsController
  prepend_before_action -> { @namespace = ::Emoney }
end
