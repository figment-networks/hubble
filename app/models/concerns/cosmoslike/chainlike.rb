module Cosmoslike::Chainlike
  extend ActiveSupport::Concern

  included do |klass|
    namespace = klass.name.deconstantize.constantize

    acts_as_list scope: [:dead], add_new_at: :top

    has_many :blocks, class_name: "#{namespace}::Block", dependent: :delete_all
    has_many :validators, class_name: "#{namespace}::Validator", dependent: :delete_all

    has_many :events, as: :chainlike, class_name: 'Common::ValidatorEvent', dependent: :delete_all
    has_many :latches, as: :chainlike, class_name: 'Common::ValidatorEventLatch', dependent: :delete_all

    has_many :average_snapshots, as: :chainlike, class_name: 'Stats::AverageSnapshot', dependent: :delete_all
    has_many :sync_logs, as: :chainlike, class_name: 'Stats::SyncLog', dependent: :delete_all
    has_many :daily_sync_logs, as: :chainlike, class_name: 'Stats::DailySyncLog', dependent: :delete_all

    has_many :accounts, class_name: "#{namespace}::Account", dependent: :delete_all
    has_many :governance_proposals, class_name: "#{namespace}::Governance::Proposal", dependent: :delete_all

    has_many :watches, as: :chainlike, class_name: 'Common::Watch', dependent: :delete_all

    has_one :faucet, class_name: "#{namespace}::Faucet", dependent: :destroy

    validates :name, presence: true, allow_blank: false
    validates :slug, presence: true, uniqueness: true, format: { with: /[a-z0-9-]+/ }, allow_blank: false
    validate :validator_event_defs_format

    default_scope -> { order( 'position ASC' ) }

    scope :alive,      -> { where.not( dead: true ) }
    scope :has_synced, -> { where.not( last_sync_time: nil ) }
    scope :enabled,    -> { where( disabled: false ) }
    scope :primary,    -> { find_by( primary: true ) || order('created_at DESC').first }
  end

  ASSET = 'cosmoslike'
  EVENTS_PAGE_SIZE = 20

  def to_param; slug; end
  def namespace; self.class.name.deconstantize.constantize; end
  def enabled?; !disabled?; end
  def has_csir?; false; end
  def has_dashboard?; true; end

  def primary_token
    token_map.each { |k,v| return k if v['primary'] }
    token_map.keys.first # fallback, should not happen
  end

  def prefixes
    self.class::PREFIXES
  end

  def sdk_gte?( version_number )
    Gem::Version.new( self.sdk_version ) >= Gem::Version.new( version_number )
  end
  def sdk_lt?( version_number )
    Gem::Version.new( self.sdk_version ) < Gem::Version.new( version_number )
  end

  def skip_to_now!
    height = syncer.get_head_height - 100
    self.latest_local_height = height
    self.history_height = height
    self.validator_event_defs = self.validator_event_defs.map { |defn| defn['height'] = height; defn }
    self.save!
  end

  TWITTER_CONFIG_FIELDS = %w{ consumer_key consumer_secret access_token access_secret }
  def has_twitter_config?
    TWITTER_CONFIG_FIELDS.all? do |field|
      !self.twitter_events_config[field].nil?
    end
  end

  def get_event_height( defn_id )
    defn = self.validator_event_defs.find { |defn| defn['unique_id'] == defn_id }
    defn ? (defn['height'] || 0) : 0
  end

  def set_event_height!( defn_id, height )
    self.validator_event_defs_will_change!
    self.validator_event_defs = self.validator_event_defs.map do |defn|
      if defn['unique_id'] == defn_id
        defn['height'] = height
      end
      defn
    end
    self.save!
  end

  def syncer( timeout=1500 )
    @_syncer ||= namespace::SyncBase.new( self, timeout )
  end

  def can_communicate_with_node?
    return false if self.ext_id.blank?
    begin
      # ensure lcd and rpc are available
      syncer.get_stake_info
      syncer.get_node_chain == self.ext_id
    rescue
      Rails.logger.error $!.message
      nil
    end
  end

  def active_validators_at_height( height )
    block = blocks.find_by(height: height) || namespace::Block.stub(self, height)
    validators.where(address: block.validator_set.keys)
  rescue
    []
  end

  def average_block_time( last_n_blocks: 100 )
    times = []
    lastest_blocks = blocks.limit( last_n_blocks ).to_a

    latest_time = lastest_blocks.shift.timestamp

    # include now, so that network being down results in
    # slowly creeping average block time?
    # times << Time.now.utc - latest_time

    lastest_blocks.each do |block|
      times << latest_time - block.timestamp
      latest_time = block.timestamp
    end

    return 0 if times.count.zero?
    times.reduce(:+) / times.count
  end

  def total_current_voting_power
    validators.total_voting_power( self )
  end

  def voting_power_online
    online = validators.where( address: blocks.first.precommitters )
    online.sum { |v| v.current_voting_power || 0 }
  end

  def failing_sync?
    failed_sync_count > 0
  end

  def sync_failed!
    Rails.logger.error "Chain failing sync! #{self.inspect}"
    increment! :failed_sync_count
  end

  def sync_completed!
    update_attributes failed_sync_count: 0
  end

  def governance_params_synced?
    governance != {}
  end

  def governance_params
    @governance_params ||= namespace::GovernanceParamsDecorator.new(governance)
  end

  def progressing!
    update_attributes halted_at: nil
  end

  def has_halted!
    update_attributes halted_at: DateTime.now
  end

  def halted?
    !halted_at.nil?
  end

  private

  def validator_event_defs_format
    if validator_event_defs.any? { |defn| defn.keys.blank? }
      errors.add(:validator_event_defs, "does not have correct format (#{validator_event_defs.inspect})")
    end
  end
end
