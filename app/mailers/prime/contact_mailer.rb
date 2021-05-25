class Prime::ContactMailer < ApplicationMailer
  def user_submit
    mail(
      to: 'sales@figment.io',
      subject: 'New Prime User Submission - '
    )
  end
end
