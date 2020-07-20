class Polkadot::Chain < ApplicationRecord
  ASSET = "polkadot"

  validates :name, presence: true
  validates :slug, format: { with: /[a-z0-9-]+/ }, uniqueness: true, presence: true
  validates :api_url, presence: true

  # TODO: validate - ensure there's only single primary chain, or fix in admin create controller

  def network_name
    "Polkadot"
  end

  def to_param
    slug
  end

  def enabled?
    !disabled
  end

  def status
    # TODO: replace with a call to client
    OpenStruct.new({ app_version: '1', last_block_height: 100, last_block_time: Time.now })
  end

  # TODO: Replace KSM with DOTs when we switch from Kusama to Polkadot
  def token_map
    {
      'KSM' => {
        display: 'KSM',
        factor: 12,
        primary: true
      }
    }.with_indifferent_access
  end
end
