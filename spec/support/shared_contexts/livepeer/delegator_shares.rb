shared_context 'Livepeer delegator shares' do
  let(:transcoders) do
    %w[
      0xbde0750c5c3bd4afdb495e26b790f7771ccd8d22
      0xf70f722ef2b093b253fd237aa8e32792fe1b64a8
    ]
  end

  let(:delegators) do
    %w[
      0x5583cece0ef08e93b462b4aa5d8431cfd8e61d56
      0xcb31d90803f50bc5915925fe40d97cc6b71f0e04
    ]
  end

  let!(:chains) { create_list(:livepeer_chain, 2) }

  let!(:rounds) do
    [
      create_round(chains[0], number: 1000, initialized_at: 2.days.ago),
      create_round(chains[0], number: 1001, initialized_at: 1.day.ago),
      create_round(chains[1], number: 1001, initialized_at: 1.day.ago)
    ]
  end

  let!(:pools) do
    [
      create(:livepeer_pool, round: rounds[0], transcoder_address: transcoders[0]),
      create(:livepeer_pool, round: rounds[1], transcoder_address: transcoders[1]),
      create(:livepeer_pool, round: rounds[2], transcoder_address: transcoders[1])
    ]
  end

  let!(:shares) do
    [
      create_share(pools[0], delegators[0], fees: 10, reward_tokens: 100),
      create_share(pools[0], delegators[0], fees: 20, reward_tokens: 200),
      create_share(pools[1], delegators[0], fees: 30, reward_tokens: 300),
      create_share(pools[1], delegators[1], fees: 40, reward_tokens: 400),
      create_share(pools[2], delegators[0], fees: 50, reward_tokens: 500),
      create_share(pools[2], delegators[1], fees: 60, reward_tokens: 600)
    ]
  end
end
