class Avalanche::Chain < ApplicationRecord
  include TokenMap

  ASSET = 'avalanche'.freeze

  DEFAULT_TOKEN_DISPLAY = 'AVAX'.freeze
  DEFAULT_TOKEN_REMOTE = 'avax'.freeze
  DEFAULT_TOKEN_FACTOR = 9

  validates :name, presence: true
  validates :slug, format: { with: /\A[a-z0-9-]+\z/ }, uniqueness: true, presence: true
  validates :api_url, presence: true

  delegate :status, to: :client
  scope :primary, -> { find_by(primary: true) || order('created_at DESC').first }
  scope :enabled, -> { where(disabled: false) }

  def network_name
    'Avalanche'
  end

  def to_param
    slug
  end

  def enabled?
    !disabled
  end

  def client
    @client ||= Avalanche::Client.new(api_url)
  end

  def status
    @client_status ||= client.status
  end

  def last_sync_time
    @last_sync_time ||= status.sync_time
  end
end
