class Skale::Chain < ApplicationRecord
  include TokenMap

  ASSET = 'skale'.freeze

  DEFAULT_TOKEN_DISPLAY = 'SKL'.freeze
  DEFAULT_TOKEN_REMOTE = 'skl'.freeze
  DEFAULT_TOKEN_FACTOR = 18

  validates :name, presence: true
  validates :slug, format: { with: /\A[a-z0-9-]+\z/ }, uniqueness: true, presence: true
  validates :api_url, presence: true

  delegate :status, to: :client
  scope :primary, -> { find_by(primary: true) || order('created_at DESC').first }
  scope :enabled, -> { where(disabled: false) }

  def network_name
    'Skale'
  end

  def to_param
    slug
  end

  def enabled?
    !disabled
  end

  def client
    @client ||= Skale::Client.new(api_url)
  end

  def status
    @client_status ||= client.status
  end
end
