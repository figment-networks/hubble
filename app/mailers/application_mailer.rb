class ApplicationMailer < ActionMailer::Base
  include ActionView::Helpers::TextHelper
  add_template_helper NamespacedChainsHelper

  default from: "Figment Networks#{" (#{Rails.env})" unless Rails.env.production?} <notifications@secretnodes.org>"
  layout 'mailer'
end
