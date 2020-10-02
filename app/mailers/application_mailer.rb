class ApplicationMailer < ActionMailer::Base
  include ActionView::Helpers::TextHelper
  add_template_helper NamespacedChainsHelper

  default from: "Figment#{" (#{Rails.env})" unless Rails.env.production?} <notifications@figment.io>"
  layout 'mailer'
end
