require 'features_helper'

feature 'Livepeer Rounds' do
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
      transcoder_address: '0x9180f738130252a423a65c73191b71321b533ad3',
      total_stake: 2_000_000,
      reward_tokens: nil
    )
  end

  scenario 'visiting the round page' do
    visit "/livepeer/chains/#{chain.slug}"

    click_link "#{round.number}"

    expect(page).to have_content("Livepeer — #{chain.name}")
    expect(page).to have_content("Round #{round.number}")

    expect(page).to have_content('9180F738130252A423A65C73191B71321B533AD3')
    expect(page).to have_content('2M LPT')
    expect(page).to have_content('MISSED')

    expect(page).to have_content("Timestamp\n2020-07-19 @ 08:53 UTC")
    expect(page).to have_content("Mintable Tokens\n9.88K LPT")
  end
end
