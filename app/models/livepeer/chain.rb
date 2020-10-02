class Livepeer::Chain < ApplicationRecord
  default_scope { order(:position) }

  ASSET = 'livepeer'.freeze
  SYNC_INTERVAL = 10.minutes

  DEFAULT_TOKEN_DISPLAY = 'LPT'.freeze
  DEFAULT_TOKEN_REMOTE = 'livepeer'.freeze
  DEFAULT_TOKEN_FACTOR = 18

  acts_as_list add_new_at: :top

  has_many :rounds, dependent: :delete_all
  has_many :orchestrators, dependent: :delete_all
  has_many :delegators, dependent: :delete_all

  has_many :pools, through: :rounds
  has_many :shares, through: :pools
  has_many :stakes, through: :rounds
  has_many :bonds, through: :rounds
  has_many :unbonds, through: :rounds
  has_many :rebonds, through: :rounds
  has_many :events, through: :rounds

  has_many :reward_cut_changes, through: :rounds
  has_many :missed_reward_calls, through: :rounds
  has_many :deactivations, through: :rounds
  has_many :slashings, through: :rounds

  has_many :delegator_lists, dependent: :delete_all
  has_many :alert_subscriptions, through: :delegator_lists

  validates :name, presence: true
  validates :slug, format: { with: /\A[a-z0-9-]+\z/ }, uniqueness: true
  validates :subgraph_url, url: true

  before_destroy :purge_data, prepend: true

  scope :enabled, -> { where(disabled: false) }
  scope :has_synced, -> { where.not(last_sync_time: nil) }
  scope :primary, -> { find_by(primary: true) || order(created_at: :desc).first }

  def network_name
    'Livepeer'
  end

  def to_param
    slug
  end

  def enabled?
    !disabled?
  end

  def has_dashboard?
    true
  end

  def failing_sync?
    false
  end

  def alertable_type
    'delegator_list'
  end

  private

  def purge_data
    logger.silence do
      associations = %i[shares pools stakes bonds unbonds rebonds
                        events alert_subscriptions]

      associations.each do |association|
        ids = send(association).pluck(:id)
        send(association).model.where(id: ids).delete_all
      end
    end
  end
end
