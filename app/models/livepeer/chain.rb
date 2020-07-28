class Livepeer::Chain < ApplicationRecord
  default_scope { order(:position) }

  ASSET = 'livepeer'
  SYNC_INTERVAL = 10.minutes

  acts_as_list add_new_at: :top

  has_many :rounds, dependent: :delete_all
  has_many :transcoders, dependent: :delete_all

  has_many :pools, through: :rounds
  has_many :shares, through: :pools
  has_many :stakes, through: :rounds
  has_many :bonds, through: :rounds
  has_many :unbonds, through: :rounds
  has_many :rebonds, through: :rounds

  has_many :delegator_lists, dependent: :delete_all

  validates :name, presence: true
  validates :slug, format: { with: /[a-z0-9-]+/ }, uniqueness: true
  validates :subgraph_url, url: true

  before_destroy :purge_data, prepend: true

  scope :enabled, -> { where(disabled: false) }
  scope :has_synced, -> { where.not(last_sync_time: nil) }

  def network_name; 'Livepeer'; end
  def to_param; slug; end
  def enabled?; !disabled?; end

  private

  def purge_data
    logger.silence do
      associations = %i[shares pools stakes bonds unbonds rebonds]

      associations.each do |association|
        ids = send(association).pluck(:id)
        send(association).model.where(id: ids).delete_all
      end
    end
  end
end
