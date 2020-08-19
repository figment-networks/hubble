shared_context 'Livepeer delegator stakes' do
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

  let!(:stakes) do
    [
      create_stake(rounds[0], delegators[0], pending_stake: 100, unclaimed_stake: 50),
      create_stake(rounds[0], delegators[1], pending_stake: 200, unclaimed_stake: 100),
      create_stake(rounds[1], delegators[0], pending_stake: 300, unclaimed_stake: 150),
      create_stake(rounds[1], delegators[1], pending_stake: 400, unclaimed_stake: 200),
      create_stake(rounds[2], delegators[0], pending_stake: 500, unclaimed_stake: 250)
    ]
  end
end
