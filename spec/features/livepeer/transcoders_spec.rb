require 'features_helper'

feature 'Livepeer Transcoders' do
  let!(:chain) { create(:livepeer_chain) }
  let!(:round) { create(:livepeer_round, chain: chain) }

  let!(:transcoder) do
    create(
      :livepeer_transcoder,
      chain: chain,
      name: 'Example Transcoder',
      address: '0x9ffda5fa31c5fcc21de84a1b0a849efa0dd9d264',
      reward_cut: 30,
      fee_share: 0,
      total_stake: 1_234_567
    )
  end

  before do
    create(
      :livepeer_event,
      round: round,
      type: 'Livepeer::Events::RewardCutChange',
      timestamp: '2020-07-24 12:16',
      transcoder_address: transcoder.address,
      data: { reward_cut: 30 }
    )
  end

  scenario 'visiting the transcoder page' do
    visit "/livepeer/chains/#{chain.slug}"

    click_link 'Example Transcoder'

    expect(page).to have_content('Example Transcoder')
    expect(page).to have_content('9FFDA5FA31C5FCC21DE84A1B0A849EFA0DD9D264')

    expect(page).to have_content('Event History — most recent 20')
    expect(page).to have_content('Reward cut changed to 30%')
    expect(page).to have_content("July 24, 2020\nat 12:16 UTC")

    expect(page).to have_content("Reward Cut\n30%")
    expect(page).to have_content("Fee Share\n0%")
    expect(page).to have_content("Total Stake\n1.23M LPT")
  end
end
