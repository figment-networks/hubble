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

  def decorate_user_network_reward(network)
    "#{number_with_delimiter(user_network_rewards(network).round(2))} #{network.primary.reward_token_display}"
  end
end
