shared_context 'Livepeer delegator data' do
  let(:delegators) do
    %w[
      0x5583cece0ef08e93b462b4aa5d8431cfd8e61d56
      0xcb31d90803f50bc5915925fe40d97cc6b71f0e04
    ]
  end

  let!(:chain) { create(:livepeer_chain) }

  let!(:rounds) do
    [
      create_round(chain, number: 1000, initialized_at: 2.days.ago),
      create_round(chain, number: 1001, initialized_at: 1.day.ago)
    ]
  end

  let!(:unbond_rounds) do
    [
      create_unbond_round(chain, withdraw_round: rounds[0]),
      create_unbond_round(chain, withdraw_round: rounds[1])
    ]
  end

  let!(:withdraw_rounds) do
    [
      create_withdraw_round(chain, unbond_round: rounds[0]),
      create_withdraw_round(chain, unbond_round: rounds[1])
    ]
  end

  let!(:rebond_rounds) do
    [
      create_round_relative_to(unbond_rounds[1], interval: 5),
      create_round_relative_to(rounds[1], interval: 3)
    ]
  end

  let!(:pools) do
    [
      create(:livepeer_pool, round: rounds[0]),
      create(:livepeer_pool, round: rounds[1])
    ]
  end

  let!(:shares) do
    [
      create_share(pools[0], delegators[0], fees: 10, reward_tokens: 100),
      create_share(pools[0], delegators[1], fees: 20, reward_tokens: 200),
      create_share(pools[1], delegators[0], fees: 30, reward_tokens: 300),
      create_share(pools[1], delegators[1], fees: 40, reward_tokens: 400)
    ]
  end

  let!(:stakes) do
    [
      create_stake(rounds[0], delegators[0], pending_stake: 100, unclaimed_stake: 50),
      create_stake(rounds[0], delegators[1], pending_stake: 200, unclaimed_stake: 100),
      create_stake(rounds[1], delegators[0], pending_stake: 300, unclaimed_stake: 150),
      create_stake(rounds[1], delegators[1], pending_stake: 400, unclaimed_stake: 200)
    ]
  end

  let!(:unbonds) do
    [
      create_unbond(unbond_rounds[0], rounds[0], delegators[0], amount: 100),
      create_unbond(unbond_rounds[0], rounds[0], delegators[1], amount: 200),
      create_unbond(unbond_rounds[1], rounds[1], delegators[0], amount: 300),
      create_unbond(unbond_rounds[1], rounds[1], delegators[1], amount: 400),
      create_unbond(rounds[0], withdraw_rounds[0], delegators[0], amount: 500),
      create_unbond(rounds[0], withdraw_rounds[0], delegators[1], amount: 600),
      create_unbond(rounds[1], withdraw_rounds[1], delegators[0], amount: 700),
      create_unbond(rounds[1], withdraw_rounds[1], delegators[1], amount: 800)
    ]
  end

  let!(:rebonds) do
    [
      create_rebond(unbonds[0]),
      create_rebond(unbonds[3], rebond_rounds[0]),
      create_rebond(unbonds[5]),
      create_rebond(unbonds[6], rebond_rounds[1])
    ]
  end
end
