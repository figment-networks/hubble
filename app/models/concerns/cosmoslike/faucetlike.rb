module Cosmoslike::Faucetlike
  extend ActiveSupport::Concern

  included do |klass|
    namespace = klass.name.deconstantize.constantize

    belongs_to :chain, class_name: "#{namespace}::Chain"
    has_many :transactions, class_name: 'Stats::FaucetTransaction', dependent: :delete_all, as: :faucetlike

    attribute :private_key
    attr_encrypted :private_key, key: proc { Rails.application.secrets.faucet_key_base }
    validates :encrypted_private_key, presence: true, allow_nil: false, allow_blank: false

    scope :enabled, -> { where(disabled: false) }

    before_validation :set_account_fields_and_defaults, on: :create
  end

  DEFAULT_DISBURSEMENT_AMOUNT = '100'.freeze
  DEFAULT_FEE_AMOUNT = '2'.freeze
  THROTTLE = Rails.env.production? ? 1.hour : 5.minutes

  def enabled?
    !disabled?
  end

  def ready?
    chain.syncer(800).get_account_info(address)
  end

  def can_fund?(user:, address:, ip:)
    recent = latest_funding(user: user, address: address, ip: ip)
    return !recent || recent.created_at < THROTTLE.seconds.ago
  end

  def latest_funding(user:, address:, ip:)
    q = [
      ('user_id' if user),
      ('address' if address),
      'ip'
    ].compact.
      map { |field| "#{field} = ?" }.
      join(' OR ')

    bindings = [user.try(:id), address, ip].compact

    transactions.successful.find_by(q, *bindings)
  end

  def balance
    chain.syncer(1000).get_account_info(address)['value']['coins'].find { |c| c['denom'] == denom }['amount']
  rescue StandardError
    nil
  end

  def generate_signed_tx(to_address)
    syncer = chain.syncer(6000)
    account_info = syncer.get_account_info(address)

    tx = {
      msgs: [
        {
          type: 'cosmos-sdk/MsgSend',
          value: {
            amount: [{ amount: disbursement_amount, denom: denom }],
            from_address: address,
            to_address: to_address
          }
        }
      ],
      fee: {
        amount: [{ amount: fee_amount, denom: denom }],
        gas: '200000'
      },
      account_number: account_info['value']['account_number'],
      sequence: current_sequence,
      chain_id: chain.ext_id,
      memo: "Community Faucet for #{chain.ext_id}#{' (testnet)' if chain.testnet?} via https://hubble.figment.network/#{chain.network_name.downcase}/chains/#{chain.slug}/faucet"
    }.sort_by_key(true)

    sig = secp256k1_private_key.ecdsa_sign(tx.to_json)
    serialized_sig = secp256k1_private_key.ecdsa_serialize_compact(sig)
    encoded_sig = Base64.strict_encode64(serialized_sig)

    {
      msg: tx[:msgs],
      fee: tx[:fee],
      signatures: [
        {
          account_number: tx[:account_number],
          sequence: tx[:sequence],
          signature: encoded_sig,
          pub_key: {
            type: 'tendermint/PubKeySecp256k1',
            value: Base64.strict_encode64(pubkey_bytes)
          }
        }
      ],
      memo: tx[:memo]
    }
  end

  def broadcast_tx(final_tx)
    payload = { tx: final_tx, return: 'sync' }
    result = chain.syncer(8000).broadcast_tx(payload)
    Rails.logger.info("\n\nBROADCAST RESULT: #{result.inspect}\n\n")
    ok = !result.has_key?('code') && !result.has_key?('error')

    next_sequence = (current_sequence.to_i + 1).to_s
    update_attributes(current_sequence: next_sequence) if ok

    [ok, result]
  end

  def update_sequence
    account_info = chain.syncer(5000).get_account_info(address)
    self.current_sequence = account_info ? account_info['value']['sequence'] : '0'
  end

  private

  def set_account_fields_and_defaults
    self.address = calculate_address
    self.disabled = true
    self.denom = chain.token_map[chain.primary_token]['display']
    self.disbursement_amount = DEFAULT_DISBURSEMENT_AMOUNT
    self.fee_amount = DEFAULT_FEE_AMOUNT
    update_sequence
  end

  def pubkey_bytes
    secp256k1_private_key.pubkey.serialize(compressed: true)
  end

  def calculate_address
    chain.namespace::KeyConverter.pubkey_to_addr(pubkey_bytes, chain.prefixes[:account_address])
  end

  def secp256k1_private_key
    return @_secp256k1_private_key if @_secp256k1_private_key

    raw_priv = Secp256k1::Utils.decode_hex private_key
    @_secp256k1_private_key = Secp256k1::PrivateKey.new(privkey: raw_priv)
  end
end
