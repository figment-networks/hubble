class AlertMailer < ApplicationMailer
  def instant
    @sub = params[:sub]
    @events = params[:events]

    @user = @sub.user
    @alertable = @sub.alertable

    mail(
      to: @user.email,
      subject: "HUBBLE ALERT - #{@alertable.long_name} on #{@alertable.chain.network_name}/#{@alertable.chain.name} (#{pluralize(
        @events.count, 'new event'
      )})"
    )
  end

  def daily
    @sub = params[:sub]
    @date = params[:date]
    @events = params[:events]

    @user = @sub.user
    @alertable = @sub.alertable

    mail(
      to: @user.email,
      subject: "HUBBLE DAILY DIGEST - #{@alertable.long_name} on #{@alertable.chain.network_name}/#{@alertable.chain.name} (#{pluralize(
        @events.count, 'new event'
      )})"
    )
  end
end
