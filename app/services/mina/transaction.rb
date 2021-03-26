module Mina
  class Transaction < Common::Resource
    TYPE_NAMES = {
      'coinbase' => 'Coinbase',
      'delegation' => 'Delegation',
      'snark_fee' => 'Snark Fee',
      'fee_transfer_via_coinbase' => 'Fee Transfer via Coinbase',
      'payment' => 'Payment',
      'fee_transfer' => 'Fee Transfer'
    }.freeze

    field :id
    field :type
    field :hash
    field :block_hash
    field :height, source: :block_height
    field :time, type: :timestamp
    field :sender
    field :receiver
    field :amount, type: :integer
    field :fee, type: :integer
    field :nonce
    field :sequence_number
    field :memo
    field :status
    field :failure_reason

    def formatted_type
      TYPE_NAMES[type] || type
    end

    def applied?
      status == 'applied'
    end
  end
end
