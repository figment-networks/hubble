class Cosmoslike::FaucetTransactionsController < Cosmoslike::BaseController
  include AdminHelper

  before_action :ensure_faucet

  def create
    # valid captcha?
    if !current_admin && !valid_captcha?
      flash[:error] = 'Captcha verification failed. Please try again.'
      render json: { redirect: namespaced_path( 'faucet', @chain ) }
      return
    end

    address = params[:fund_this_address].strip

    if (Rails.env.development? && current_admin) || @faucet.can_fund?( user: current_user, address: address, ip: current_ip )
      tx = @faucet.generate_signed_tx( address )
      Rails.logger.debug "FINAL FAUCET TX: #{tx}"
      ok, r = @faucet.broadcast_tx( tx )

      tr = @faucet.transactions.create(
        user: current_user,
        address: address,
        ip: current_ip,
        txhash: (r['txhash'] rescue nil),
        result_data: r,
        error: !ok
      )

      if tr.valid? && tr.txhash && ok
        tr.update_attributes completed_at: Time.now
        render json: {
          check: namespaced_path( 'transaction', tr.txhash, format: 'json' ),
          redirect: namespaced_path( 'transaction', tr.txhash )
        }
      else
        error_messages = tr.errors.full_messages
        if tr.valid? && !ok
          error_messages << "Broadcast Error: #{r['error_message'] || r['error'] || 'Unknown!'}"
          @faucet.update_sequence
          @faucet.save
        end
        flash[:error] = error_messages.join("<br/>")
        render json: { redirect: namespaced_path( 'faucet' ) }
      end

    else
      recent = @faucet.latest_funding( user: current_user, address: address, ip: current_ip )
      if recent
        # puts "\n\n#{Time.now.utc}\n#{recent.created_at}\n#{recent.created_at + @faucet.delay.seconds}\n\n"
        how_long = distance_of_time_in_words( recent.created_at + @faucet.class::THROTTLE.seconds, Time.now.utc, true, highest_measures: 2 )
        flash[:error] = "Please wait #{how_long} before requesting more funding."
      else
        flash[:error] = "An unknown error occurred trying to create that transaction. Sorry!"
      end

      render json: { redirect: namespaced_path( 'faucet' ) }
    end
  end

  private

  def ensure_faucet
    @faucet = @chain.faucet
    raise ActiveRecord::RecordNotFound unless @faucet
  end

  def valid_captcha?
    begin
      req = Curl.post 'https://www.google.com/recaptcha/api/siteverify',
                      secret: Rails.application.secrets.recaptcha[:secret],
                      response: params['g-recaptcha-response'],
                      remoteip: current_ip
      res = JSON.parse( req.body_str )
      return res['success']
    rescue
      Rails.logger.error $!.message
      return false
    end
  end

end
