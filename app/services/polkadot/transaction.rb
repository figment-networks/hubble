module Polkadot
  class Transaction < Common::Resource
    attr_accessor :id,
                  :time,
                  :block,
                  :extrinsic_index,
                  :extrinsic_hash,
                  :module,
                  :call,
                  :description,
                  :address,
                  :nonce,
                  :section,
                  :signature,
                  :signer,
                  :parameters

    def initialize(attrs = {})
      super(attrs)

      @time = Time.zone.parse(time)
    end

    #TODO: put these in a TransactionDecorator, name properly
    HUMANIZED_CALLS = { 'transfer' => 'Send' }

    def humanized_call
      HUMANIZED_CALLS[call] || call
    end

    HUMANIZED_PARAMETERS = {
      'destination' => 'To',
      'value' => 'Amount'
    }

    def humanized_parameters
      parameters.inject({}) do |result, (key, value)|
        result[HUMANIZED_PARAMETERS[key] || key] = value
        result
      end
    end
  end
end
