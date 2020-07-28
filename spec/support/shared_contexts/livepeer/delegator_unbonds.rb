shared_context 'Livepeer delegator unbonds' do
  let(:delegators) do
    %w{
      0xcb31d90803f50bc5915925fe40d97cc6b71f0e04
      0x5583cece0ef08e93b462b4aa5d8431cfd8e61d56
    }
  end

  let!(:chains) { create_list(:livepeer_chain, 2) }

  let!(:rounds) do
    [
      create_round(chains[0], number: 1000, initialized_at: 10.days.ago),
      create_round(chains[0], number: 1001, initialized_at: 9.days.ago),
      create_round(chains[0], number: 1002, initialized_at: 8.days.ago),
      create_round(chains[1], number: 1002, initialized_at: 8.days.ago)
    ]
  end

  let!(:withdraw_rounds) do
    [
      create_round(chains[0], number: 1007, initialized_at: 3.days.ago),
      create_round(chains[0], number: 1008, initialized_at: 2.days.ago),
      create_round(chains[0], number: 1009, initialized_at: 1.day.ago),
      create_round(chains[1], number: 1009, initialized_at: 1.day.ago)
    ]
  end

  let!(:unbonds) do
    [
      create_unbond(rounds[0], withdraw_rounds[0], delegators[0], amount: 100),
      create_unbond(rounds[0], withdraw_rounds[0], delegators[0], amount: 200),
      create_unbond(rounds[0], withdraw_rounds[0], delegators[0], amount: 300),
      create_unbond(rounds[0], withdraw_rounds[0], delegators[1], amount: 400),
      create_unbond(rounds[1], withdraw_rounds[1], delegators[1], amount: 500),
      create_unbond(rounds[1], withdraw_rounds[1], delegators[1], amount: 600),
      create_unbond(rounds[2], withdraw_rounds[2], delegators[1], amount: 700),
      create_unbond(rounds[3], withdraw_rounds[3], delegators[0], amount: 800),
      create_unbond(rounds[3], withdraw_rounds[3], delegators[1], amount: 900)
    ]
  end

  let!(:rebonds) do
    [
      create_rebond(unbonds[0], rounds[1]),
      create_rebond(unbonds[2]),
      create_rebond(unbonds[4], rounds[2]),
      create_rebond(unbonds[6]),
      create_rebond(unbonds[8])
    ]
  end
end
