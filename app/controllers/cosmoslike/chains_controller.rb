class Cosmoslike::ChainsController < Cosmoslike::BaseController

  def show
    @validators = @chain.validators
    @governance = @chain.governance

    page_title @chain.network_name, @chain.name, 'Overview', 'Validators, Governance, and Community Pool'
    meta_description "#{@chain.network_name} -- #{@chain.name} list of Validators, Address/Name, Voting Power, Uptime, Current Block and Governance"

    if @latest_block.nil?
      redirect_to namespaced_path( 'prestart', pre_path: true )
    end
  end

  def search
    query = params[:query].strip

    if query =~ /^\d+$/
      redirect_to namespaced_path( 'block', query )

    elsif query.downcase.starts_with?( @chain.prefixes[:account_address] )
      redirect_to namespaced_path( 'account', query.downcase )

    elsif query.downcase.starts_with?( @chain.prefixes[:validator_operator_address] )
      validator = @chain.validators.find_by( owner: query.downcase )
      if validator.nil?
        render template: 'cosmoslike/chains/search_failed'
        return
      else
        redirect_to namespaced_path( 'validator', validator )
      end

    elsif query.upcase == query
      redirect_to namespaced_path( 'transaction', query )

    else
      if query.length >= 3
        # maybe try to find via validator moniker?
        validator = @chain.validators.where( 'moniker ILIKE ?', "%#{query}%" ).order('current_voting_power DESC')
        if validator.any?
          redirect_to namespaced_path( 'validator', validator.first )
          return
        end

        # how about a transaction then?
        tx = @chain.syncer(250).get_transaction( query )
        if tx
          redirect_to namespaced_path( 'transaction', tx['txhash'] )
          return
        end
      end

      render template: 'cosmoslike/chains/search_failed'
      return

    end
  end

  def halted
    if action_name == 'halted' && !(@chain.halted? || Rails.env.development?)
      redirect_to namespaced_path
      return
    end
    render template: 'cosmoslike/chains/halted'
  end
  alias :prestart :halted

  def broadcast
    tx = { tx: params[:payload], return: 'sync' }
    r = @chain.syncer(5000).broadcast_tx(tx)
    ok = !r.has_key?('code') && !r.has_key?('error')
    Rails.logger.info("\n\nBROADCAST RESULT: #{r.inspect}\n\n")
    render json: { ok: ok }.merge(r)
  end
end
