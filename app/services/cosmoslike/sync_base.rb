class Cosmoslike::SyncBase
  class CriticalError < StandardError; end

  def initialize( chain, timeout_ms=10_000 )
    @chain = chain
    @timeout = timeout_ms

    begin
      ext_id = get_node_chain
    rescue
      puts "#{$!.message}"
    end

    if !ext_id
      chain.sync_failed!
      raise CriticalError.new("Unable to communicate with node!")
    end

    if @chain.ext_id.blank?
      @chain.update_attributes ext_id: ext_id
    end

    if ext_id != @chain.ext_id
      chain.sync_failed!
      raise CriticalError.new("Node is running on chain #{ext_id} and cannot sync #{@chain.ext_id}.")
    end
  end

  def get_status
    rpc_get( 'status' )
  end

  def get_head_height
    get_status['result']['sync_info']['latest_block_height'].to_i
  end

  def get_block( height )
    rpc_get( 'block', height: height )
  end

  def get_blocks( first, last )
    rpc_get( 'blockchain', minHeight: first, maxHeight: last )
  end

  def get_commit( height )
    rpc_get( 'commit', height: height )
  end

  def get_validator_set( height )
    r = rpc_get( 'validators', height: height )
    begin
      r['result']['validators']
    rescue
      raise RuntimeError.new("Could not retrieve validator set at height #{height}. #{r}")
    end
  end

  def get_staking_pool
    lcd_get( 'staking/pool' )
  end

  def get_transaction( hash )
    r = lcd_get( [ 'txs', hash ] )
    return nil if !r.is_a?(Hash)
    return nil if r.has_key?('error')
    r
  end

  def get_transactions( params=nil )
    params ||= {}
    params['limit'] = 1000
    lcd_get( 'txs', params )
  end

  def get_account_info( addr )
    lcd_get( [ 'auth/accounts', addr ] )
  end

  def get_key(name)
    lcd_get( [ 'keys', name ] )
  end

  def get_keys
    r = lcd_get( 'keys' )
    return r if r.is_a? Array
    return []
  end

  def get_new_seed
    lcd_get( 'keys/seed' )
  end

  def create_key( name, password )
    seed = get_new_seed.strip
    lcd_post( 'keys', name: name, password: password, seed: seed )
    get_key( name )
    seed
  end

  def get_stake_info
    path = 'staking/validators'
    r = lcd_get( path )
    r.is_a?( Array ) ? r : nil
  end

  def get_genesis
    rpc_get( 'genesis' )
  end

  def get_consensus_state
    rpc_get( 'dump_consensus_state' )
  end

  def get_node_chain
    result = get_status
    result['result']['node_info']['network']
  end

  def get_canonical_block_height
    get_status['result']['sync_info']['latest_block_height'].to_i - 1
  end

  def get_community_pool
    lcd_get('distribution/community_pool') rescue nil
  end

  def get_governance
    tally_params = lcd_get('gov/parameters/tallying')
    voting_params = lcd_get('gov/parameters/voting')
    deposit_params = lcd_get('gov/parameters/deposit')

    {
      'tally_params' => tally_params.is_a?(Hash) ? tally_params : nil,
      'voting_params' => voting_params.is_a?(Hash) ? voting_params : nil,
      'deposit_params' => deposit_params.is_a?(Hash) ? deposit_params : nil
    }.delete_if { |k, v| v.nil? }
  end

  def get_proposals
    lcd_get( 'gov/proposals' )
  end

  def get_proposal_deposits( proposal_id )
    lcd_get( [ 'gov/proposals', proposal_id, 'deposits' ] )
  end

  def get_proposal_votes( proposal_id )
    lcd_get( [ 'gov/proposals', proposal_id, 'votes' ] )
  end

  def get_proposal_tally( proposal_id )
    lcd_get( [ 'gov/proposals', proposal_id, 'tally' ] )
  end

  def get_validator_delegations( validator_operator_id )
    lcd_get( [ 'staking/validators', validator_operator_id, 'delegations' ] ) || []
  end

  def get_validator_unbonding_delegations( validator_operator_id )
    lcd_get( [ 'staking/validators', validator_operator_id, 'unbonding_delegations' ] ) || []
  end

  def get_validator_rewards( validator_operator_id )
    lcd_get( [ 'distribution/validators', validator_operator_id, 'rewards' ] )
  end

  def get_validator_commission( validator_operator_id )
    r = lcd_get( [ 'distribution/validators', validator_operator_id ] )
    return [] if !r['val_commission']
    r['val_commission']
  end

  def get_account_delegations( account )
    lcd_get( [ 'staking/delegators', account, 'delegations' ] )
  end

  def get_account_unbonding_delegations( account )
    lcd_get( [ 'staking/delegators', account, 'unbonding_delegations' ] )
  end

  def get_account_balances( account )
    lcd_get( [ 'bank/balances', account ] )
  end

  def get_account_rewards( account, validator=nil )
    r = lcd_get( [ 'distribution/delegators', account, 'rewards', validator ].compact )
    if r.is_a?(Array)
      return r
    elsif r.is_a?(Hash) && r.has_key?('total')
      r['total']
    end
  end

  def get_account_delegation_transactions( account )
    r = lcd_get( [ 'staking/delegators', account, 'txs' ] )
    if r.is_a?(Array) && r[0].is_a?(Hash) && r[0].has_key?('txs')
      return r.map { |thing| thing['txs'] }.flatten
    else
      return r
    end
  end

  def broadcast_tx( signed_tx )
    final_json = signed_tx.to_json
    # Rails.logger.debug "FINAL TX PAYLOAD: #{final_json}"
    r = lcd_post( 'txs', final_json )

    # add human readable error to payload
    if !r['code'].blank?
      message = case r['code']
                when 1 then 'Internal Error'
                when 2 then 'Error decoding transaction'
                when 3 then 'Invalid sequence'
                when 4 then 'Unauthorized'
                when 5 then 'Insufficient funds'
                when 6 then 'Unknown request'
                when 7 then 'Invalid address'
                when 8 then 'Invalid public key'
                when 9 then 'Unknown address'
                when 10 then 'Insufficient coins'
                when 11 then 'Invalid coins'
                when 12 then 'Out of gas'
                when 13 then 'Memo too large'
                when 14 then 'Insufficient fee'
                when 15 then 'Too many signatures'
                when 16 then 'Gas overflow'
                when 17 then 'No signatures'
                else nil
                end
      r['error_message'] = message if message
    end

    r
  end

  private

  CACHE_VERSION = 1

  def rpc_get( path, params=nil )
    path = path.join('/') if path.is_a?(Array)

    url = URI::Generic.build(
      scheme: @chain.use_ssl_for_rpc? ? 'https' : 'http',
      host: @chain.rpc_host.blank? ? 'localhost' : @chain.rpc_host,
      port: @chain.rpc_port.blank? ? API_DEFAULTS[:rpc_host] : @chain.rpc_port,
      path: [@chain.rpc_path.sub(/\/$/, ''), path].join('/'),
      query: params ? params.to_query : nil
    ).to_s

    body = Rails.cache.fetch( ['rpc_get', @chain.network_name.downcase, @chain.ext_id.to_s, url].join('-'), force: Rails.env.development?, expires_in: 30.seconds, version: CACHE_VERSION ) do
      start_time = Time.now.utc.to_f
      Rails.logger.debug "#{@chain.network_name} RPC GET: #{url}"
      r = Typhoeus.get( url, timeout_ms: @timeout * 2, connecttimeout_ms: @timeout )
      end_time = Time.now.utc.to_f
      Rails.logger.debug "#{@chain.network_name} RPC #{path} took #{end_time - start_time} seconds" unless Rails.env.production?
      r.body
    end

    JSON.load( body ) rescue body
  end

  def lcd_get( path, params=nil )
    path = path.join('/') if path.is_a?(Array)

    url = URI::Generic.build(
      scheme: @chain.use_ssl_for_lcd? ? 'https' : 'http',
      host: @chain.lcd_host.blank? ? 'localhost' : @chain.lcd_host,
      port: @chain.lcd_port.blank? ? API_DEFAULTS[:lcd_host] : @chain.lcd_port,
      path: [@chain.lcd_path.to_s.sub(/\/$/, ''), path].join('/'),
      query: params ? params.to_query : nil
    ).to_s

    body = Rails.cache.fetch( ['lcd_get', @chain.network_name.downcase, @chain.ext_id.to_s, url].join('-'), force: Rails.env.development?, expires_in: 30.seconds, version: CACHE_VERSION ) do
      start_time = Time.now.utc.to_f
      Rails.logger.debug "#{@chain.network_name} LCD GET: #{url}"
      opts = { timeout_ms: @timeout * 2, connecttimeout_ms: @timeout }
      opts.merge!( ssl_verifypeer: false, ssl_verifyhost: 0 ) if @chain.use_ssl_for_lcd?
      r = Typhoeus.get( url, opts )
      end_time = Time.now.utc.to_f
      Rails.logger.debug "#{@chain.network_name} LCD #{path} took #{end_time - start_time} seconds" unless Rails.env.production?
      r.body
    end

    r = JSON.load( body ) rescue body
    if r.is_a?(Hash) && r.has_key?('result')
      r['result']
    else
      r
    end
  end

  def lcd_post( path, body )
    path = path.join('/') if path.is_a?(Array)

    url = URI::Generic.build(
      scheme: @chain.use_ssl_for_lcd? ? 'https' : 'http',
      host: @chain.lcd_host.blank? ? 'localhost' : @chain.lcd_host,
      port: @chain.lcd_port.blank? ? API_DEFAULTS[:lcd_host] : @chain.lcd_port,
      path: [@chain.lcd_path.sub(/\/$/, ''), path].join('/')
    ).to_s

    start_time = Time.now.utc.to_f
    Rails.logger.debug "#{@chain.network_name} LCD POST: #{url}"
    opts = { timeout_ms: @timeout * 2, connecttimeout_ms: @timeout, body: body }
    opts.merge!( ssl_verifypeer: false, ssl_verifyhost: 0 ) if @chain.use_ssl_for_lcd?
    r = Typhoeus.post( url, opts )
    end_time = Time.now.utc.to_f
    Rails.logger.debug "#{@chain.network_name} LCD #{path} took #{end_time - start_time} seconds" unless Rails.env.production?
    body = r.body

    JSON.load( body ) rescue body
  end
end
