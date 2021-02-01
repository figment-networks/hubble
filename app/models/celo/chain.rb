class Celo::Chain < ApplicationRecord
  include TokenMap

  ASSET = 'celo'.freeze

  DEFAULT_TOKEN_DISPLAY = 'CELO'.freeze
  DEFAULT_TOKEN_REMOTE = 'celo'.freeze
  DEFAULT_TOKEN_FACTOR = 21 # TODO: check and replace

  validates :name, presence: true
  validates :slug, format: { with: /\A[a-z0-9-]+\z/ }, uniqueness: true, presence: true
  validates :api_url, presence: true

  delegate :status, to: :client
  scope :primary, -> { find_by(primary: true) || order('created_at DESC').first }
  scope :enabled, -> { where(disabled: false) }

  def network_name
    'Celo'
  end

  def to_param
    slug
  end

  def enabled?
    !disabled
  end

  def client
    @client ||= Celo::Client.new(api_url)
  end

  def status
    @client_status ||= client.status
  end

  def last_sync_time
    @last_sync_time ||= status.last_indexed_time
  end
end
