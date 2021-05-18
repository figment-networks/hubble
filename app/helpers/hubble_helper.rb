module HubbleHelper
  def js_namespace
    obj = {
      # data
      mode: [],
      seed: {},
      config: {},

      # class namespaces
      Common: {},
      Stats: {},
      Cosmoslike: {},
      Livepeer: {},
      Near: {},
      Oasis: {},
      Polkadot: {},
      Mina: {},
      Celo: {},
      Avalanche: {},
      Skale: {}
    }

    if @chain.try(:primary_token)
      primary_token = @chain.primary_token
      obj[:config].merge!(
        network: @chain.network_name,
        namespace: @chain.class.to_s.split('::').first.downcase,
        denom: @chain.token_map[primary_token]['display'],
        remoteDenom: primary_token,
        remoteScaleFactor: 10 ** @chain.token_map[primary_token]['factor']
      )
      if @chain.try(:ext_id)
        obj[:config].merge!(
          chainId: @chain.ext_id,
          prefixes: @chain.prefixes,
          startedLate: !@chain.cutoff_at.nil?
        )
      end
    end

    javascript_tag "window.App = #{obj.to_json.html_safe};"
  end
end
