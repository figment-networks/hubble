module Mina
  class Transaction < Common::Resource
    TYPE_NAMES = {
      'block_reward' => 'Block Reward',
      'fee' => 'Tx Fee',
      'payment' => 'Payment',
      'delegation' => 'Delegation',
      'snark_fee' => 'Snarker Fee'
    }.freeze

    field :id
    field :type
    field :hash
    field :block_hash
    field :height
    field :time, type: :timestamp
    field :sender
    field :receiver
    field :amount, type: :integer
    field :fee, type: :integer
    field :nonce
    field :memo

    def formatted_type
      TYPE_NAMES[type]
    end

    def has_fee?
      type == 'payment' || type == 'delegation'
    end
  end
end
