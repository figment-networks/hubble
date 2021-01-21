module Terra
  class TransactionSearch
    DEFAULT_TX_PAGE_LENGTH = 25
    DEFAULT_LIMIT = DEFAULT_TX_PAGE_LENGTH + 1

    TX_TYPE_NAMES = {
      'Bank' => {
        'multisend' => 'Multisend',
        'send' => 'Send'
      },
      'Crisis' => {
        'verify_invariant' => 'Verify Invariant'
      },
      'Distribution' => {
        'withdraw_validator_commission' => 'Withdraw Validator Commission',
        'set_withdraw_address' => 'Set Withdraw Address',
        'withdraw_delegator_reward' => 'Withdraw Delegator Reward',
        'fund_community_pool' => 'Fund Community Pool'
      },
      'Evidence' => {
        'submit_evidence' => 'Submit Evidence'
      },
      'Governance' => {
        'deposit' => 'Deposit',
        'vote' => 'Vote',
        'submit_proposal' => 'Submit Proposal'
      },
      'Slashing' => {
        'unjail' => 'Unjail'
      },
      'Staking' => {
        'begin_unbonding' => 'Begin Unbonding',
        'edit_validator' => 'Edit Validator',
        'create_validator' => 'Create Validator',
        'delegate' => 'Delegate',
        'begin_redelegate' => 'Begin Redelegate'
      },
      'Internal' => {
        'error' => 'Error'
      },
      'Oracle' => {
        'swap' => 'Swap',
        'exchangeratevote' => 'Exch. Rate Vote',
        'aggregateexchangeratevote' => 'Agg. Exch. Rate Vote'
      }
    }.freeze

    class Error < StandardError; end

    attr_accessor :network
    attr_accessor :type
    attr_accessor :accounts_array
    attr_accessor :sender
    attr_accessor :receiver
    attr_accessor :show
    attr_accessor :chain_ids
    attr_accessor :memo
    attr_accessor :after_time
    attr_accessor :before_time
    attr_accessor :after_height
    attr_accessor :before_height
    attr_accessor :limit

    def initialize(chain, attrs = {})
      @network = attrs['network']

      @type = attrs['type'].reject(&:blank?) if attrs['type']

      @accounts_array = attrs['accounts_array'] == '' ? [nil] : [attrs['accounts_array']]
      case attrs['show']
      when 'sent'
        @sender = [attrs['accounts_array']] unless attrs['accounts_array'] == ''
      when 'received'
        @receiver = [attrs['accounts_array']] unless attrs['accounts_array'] == ''
      end

      @chain_ids = [attrs.fetch('chain_ids', chain.slug)]
      @memo = attrs['memo']

      @after_time = Time.zone.parse(attrs['after_time']) if attrs['after_time'].present?
      @before_time = Time.zone.parse(attrs['before_time']) if attrs['before_time'].present?
      if @after_time.present? && @before_time.present? && (@after_time > @before_time)
        raise Terra::TransactionSearch::Error, 'Start Date must be less than or equal to End Date'
      end

      @after_height = attrs['after_height'].to_i if attrs['after_height'].present?
      @before_height = attrs['before_height'].to_i if attrs['before_height'].present?
      if @after_height && @before_height && (@after_height > @before_height)
        raise Terra::TransactionSearch::Error, 'Start Height must be less than or equal to End Height'
      end
    end

    def tx_type_name(type)
      TX_TYPE_NAMES.values.each do |t|
        return t[type] if t.key?(type)
      end
      type
    end

    def to_hash(page)
      accounts_provided = accounts_array[0] && sender.blank? && receiver.blank? ? accounts_array : nil
      types = (type || []).select(&:present?).join(',')

      {
        network: network,
        type: type,
        account: accounts_provided,
        sender: sender,
        receiver: receiver,
        show: show,
        chain_ids: chain_ids,
        memo: memo,
        after_time: after_time ? after_time - 1.day : nil,
        before_time: before_time ? before_time + 1.day : nil,
        after_height: after_height ? after_height - 1 : nil,
        before_height: before_height ? before_height + 1 : nil,
        limit: DEFAULT_LIMIT,
        offset: (page - 1) * DEFAULT_LIMIT
      }.select { |_, v| v.present? }
    end
  end
end
