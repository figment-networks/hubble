module Prime::HomeHelper
  NETWORK_IMAGES = {
    'polkadot': 'polkadot.svg',
    'oasis': 'oasis.svg',
    'cosmos': 'cosmos.svg',
    'terra': 'terra.svg',
    'kava': 'kava.svg',
    'near': 'near.svg',
    'livepeer': 'livepeer.svg',
    'celo': 'celo.svg'
  }.freeze

  def active_nav_tab?(route)
    current_page?(route) ? 'active' : ''
  end

  def prime_network_image(network)
    "prime/networks/#{NETWORK_IMAGES[network.name.to_sym]}"
  end
end
