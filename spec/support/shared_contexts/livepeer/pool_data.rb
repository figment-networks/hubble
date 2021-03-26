shared_context 'Livepeer pool data' do
  let(:orchestrators) do
    %w[
      0xbde0750c5c3bd4afdb495e26b790f7771ccd8d22
      0xf70f722ef2b093b253fd237aa8e32792fe1b64a8
    ]
  end

  let!(:chains) { create_list(:livepeer_chain, 2) }

  let!(:rounds) do
    [
      create_round(chains[0], number: 1000, initialized_at: 3.days.ago),
      create_round(chains[0], number: 1001, initialized_at: 2.days.ago),
      create_round(chains[0], number: 1002, initialized_at: 1.day.ago),
      create_round(chains[1], number: 1003, initialized_at: 1.day.ago)
    ]
  end

  let!(:pools) do
    [
      create_pool(rounds[0], orchestrators[0], total_stake: 100, reward_tokens: 10),
      create_pool(rounds[0], orchestrators[1], total_stake: 200, reward_tokens: 20),
      create_pool(rounds[1], orchestrators[0], total_stake: 300, reward_tokens: 30),
      create_pool(rounds[1], orchestrators[1], total_stake: 400, reward_tokens: 40),
      create_pool(rounds[2], orchestrators[0], total_stake: 500, reward_tokens: 50),
      create_pool(rounds[3], orchestrators[0], total_stake: 600, reward_tokens: 60),
      create_pool(rounds[3], orchestrators[1], total_stake: 700, reward_tokens: 70)
    ]
  end
end
