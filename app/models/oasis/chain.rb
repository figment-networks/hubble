class Oasis::Chain < ApplicationRecord
  ASSET = 'oasis'
  SUPPORTS_LEDGER = false
  EVENTS_PAGE_SIZE = 20

  DEFAULT_TOKEN_DISPLAY = 'OASIS'
  DEFAULT_TOKEN_REMOTE = 'noasis'
  DEFAULT_TOKEN_FACTOR = 9

  default_scope -> { order( 'position ASC' ) }
  scope :alive,      -> { where.not( dead: true ) }
  scope :primary,    -> { find_by( primary: true ) || order('created_at DESC').first }
  scope :enabled,    -> { where( disabled: false ) }

  def to_param; slug; end
  def namespace; self.class.name.deconstantize.constantize; end
  def enabled?; !disabled?; end
  def network_name; 'Oasis'; end
  def token_display; 'Oasis'; end
  def primary_token; false; end

  def client
    @client ||= Oasis::Client.new(api_url)
  end

  def current_voting_power
    self.client.validators.sum(&:recent_total_shares)
  end

  def oasis_average_snapshots(kind, interval = "hour", period = "48 hours", scope = nil)
    case kind
      when 'block-time'
        self.client.blocks_summary(interval, period)
      when 'voting-power'
        self.client.validators_summary(interval, period)
      when 'validator-uptime'
        self.client.validators_summary(interval, period, scope)
    end
  end
end
