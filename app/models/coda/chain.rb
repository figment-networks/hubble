class Coda::Chain < ApplicationRecord
  ASSET = 'coda'.freeze

  DEFAULT_TOKEN_DISPLAY = 'CODA'.freeze
  DEFAULT_TOKEN_REMOTE  = 'coda'.freeze
  DEFAULT_TOKEN_FACTOR  = 9

  validates :name,    presence: true
  validates :slug,    presence: true,
                      format: { with: /[a-z0-9-]+/ },
                      uniqueness: { case_sensitive: false }

  validates :api_url, presence: true

  scope :enabled, -> { where(disabled: false) }
  scope :primary, -> { find_by(primary: true) || order('created_at DESC').first }

  delegate :status, to: :client

  def network_name
    'Coda'
  end

  def to_param
    slug
  end

  def enabled?
    !disabled
  end

  def supports_ledger?
    false
  end

  def out_of_sync?
    status&.stale?
  end

  def client
    @client ||= Coda::Client.new(api_url)
  end
end
