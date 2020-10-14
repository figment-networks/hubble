module Oasis
  class ValidatorEvent < Common::Resource
    field :height
    field :time, type: :timestamp
    field :actor
    field :kind
    field :data
    field :from
    field :to
    field :n
    field :m
    field :icon_name
    field :chain_slug

    alias kind_string kind
    alias timestamp time

    ICON_CLASSES = {
      'joined_active_set' => 'link',
      'left_active_set' => 'unlink',
      'active_escrow_balance_change_1' => 'battery-half',
      'active_escrow_balance_change_2' => 'battery-half',
      'active_escrow_balance_change_3' => 'battery-half',
      'missed_n_consecutive' => 'exclamation-circle',
      'missed_n_of_m' => 'exclamation-circle',
      'commission_change_1' => 'percentage',
      'commission_change_2' => 'percentage',
      'commission_change_3' => 'percentage'
    }.freeze

    EVENT_KINDS = {
      'joined_active_set' => 'active_set_inclusion',
      'left_active_set' => 'active_set_inclusion',
      'active_escrow_balance_change_1' => 'voting_power_change',
      'active_escrow_balance_change_2' => 'voting_power_change',
      'active_escrow_balance_change_3' => 'voting_power_change',
      'missed_n_consecutive' => 'n_consecutive',
      'missed_n_of_m' => 'n_of_m',
      'commission_change_1' => 'reward_cut_change',
      'commission_change_2' => 'reward_cut_change',
      'commission_change_3' => 'reward_cut_change'
    }.freeze

    ESCROW_BALANCE_CHANGES = %w[active_escrow_balance_change_1 active_escrow_balance_change_2
                                active_escrow_balance_change_3].freeze
    COMMISSION_CHANGES = %w[commission_change_1 commission_change_2 commission_change_3].freeze

    def initialize(attrs, chain_slug)
      super(attrs)
      @icon_name = ICON_CLASSES[kind]
      @chain_slug = chain_slug

      if active_escrow_balance_change?
        # Cosmoslike events are pre-formatted
        @from = data['before'].to_f / Oasis::Chain.find_by(slug: chain_slug).primary_token_divisor
        @to = data['after'].to_f / Oasis::Chain.find_by(slug: chain_slug).primary_token_divisor
      elsif commission_change?
        # Indexer returns 5000 for 5% change
        @from = data['before'].to_f / 1000
        @to = data['after'].to_f / 1000
      elsif n_of_m?
        @data['n'] = data['threshold']
        @data['m'] = data['max_validator_sequences']
      elsif n_consecutive?
        @data['n'] = data['threshold']
      elsif kind == 'joined_active_set'
        @data = { 'status' => 'added' }
      elsif kind == 'left_active_set'
        @data = { 'status' => 'removed' }
      end

      @kind = EVENT_KINDS[kind]
    end

    def positive?
      case kind
      when 'active_set_inclusion'
        data['status'] == 'added'
      when 'n_of_m'
        false
      when 'n_consecutive'
        false
      else
        to > from
      end
    end

    def percentage_change(round = true)
      return 100 if from.zero?

      num = to - from
      denom = from.to_f
      change = (num / denom) * 100.0
      round ? change.round(1) : change
    end

    def delta
      (to - from).to_f
    end

    def added?
      data['status'] == 'added'
    end

    def active_escrow_balance_change?
      ESCROW_BALANCE_CHANGES.include?(kind)
    end

    def commission_change?
      COMMISSION_CHANGES.include?(kind)
    end

    def n_of_m?
      kind == 'missed_n_of_m'
    end

    def n_consecutive?
      kind == 'missed_n_consecutive'
    end
  end
end
