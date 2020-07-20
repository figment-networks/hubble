module HomeHelper
  def primary_chains
    @primary_chains ||= [
      *Cosmos::Chain.alive.has_synced.primary,
      *Terra::Chain.alive.has_synced.primary,
      *Iris::Chain.alive.has_synced.primary,
      *Kava::Chain.alive.has_synced.primary,
      *Emoney::Chain.alive.has_synced.primary,
      *Livepeer::Chain.enabled.last, #TODO: add primary
      *Tezos::Chain.enabled.primary,
      *Oasis::Chain.enabled.primary,
      *Near::Chain.enabled.last #TODO: add `.primary` scope `scope :primary, -> { find_by( primary: true ) || order('created_at DESC').first }`
    ].sort_by!{ |chain| chain.network_name.downcase }
  end

  NETWORKS_IMAGES = {
    'Cosmos' => 'cosmos.svg',
    'e-Money' => 'e-money.png',
    'IRIS' => 'iris.png',
    'Kava' => 'kava.svg',
    'Livepeer' => 'livepeer.svg',
    'NEAR' => 'near.svg',
    'Oasis' => 'oasis.png',
    'Terra' => 'terra.svg',
    'Tezos' => 'tezos.png'
  }

  def network_has_image?(network_name)
    NETWORKS_IMAGES.include?(network_name)
  end

  def network_image(network_name)
    NETWORKS_IMAGES[network_name]
  end
end
