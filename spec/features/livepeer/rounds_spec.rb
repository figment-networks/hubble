require 'features_helper'

describe 'Livepeer Rounds' do
  let!(:chain) { create(:livepeer_chain) }

  let!(:round) do
    create(
      :livepeer_round,
      chain: chain,
      number: 1420,
      initialized_at: '2020-07-19 08:53',
      mintable_tokens: 9876
    )
  end

  let!(:pool) do
    create(
      :livepeer_pool,
      round: round,
      orchestrator_address: '0x9180f738130252a423a65c73191b71321b533ad3',
      total_stake: 2_000_000,
      reward_tokens: nil
    )
  end

  it 'shows the round page' do
    visit "/livepeer/chains/#{chain.slug}"

    click_link round.number.to_s

    expect(page).to have_content('9180F738130252A423A65C73191B71321B533AD3')
    expect(page).to have_content('2M LPT')
    expect(page).to have_content('MISSED')

    expect(page).to have_content('TIMESTAMP')
    expect(page).to have_content('2020-07-19 @ 08:53 UTC')
    expect(page).to have_content('MINTABLE TOKENS')
    expect(page).to have_content('9.88K LPT')
  end
end
