require 'features_helper'

describe 'Livepeer Chains' do
  let!(:chain) { create(:livepeer_chain) }
  let!(:round) { create(:livepeer_round, chain: chain) }

  let!(:orchestrator) do
    create(
      :livepeer_orchestrator,
      chain: chain,
      address: '0xfbddd6add2fde17677875a751695dcb00915f57c',
      reward_cut: 20,
      fee_share: 80
    )
  end

  it 'visiting the chain overview page', :vcr do
    visit '/'

    find("a[href='/livepeer/chains/#{chain.slug}']").click

    expect(page).to have_content("Livepeer — #{chain.name}")

    expect(page).to have_content("Orchestrators\n — 1 total")

    expect(page).to have_content('FBDDD6ADD2FDE17677875A751695DCB00915F57C')
    expect(page).to have_content('20%')
    expect(page).to have_content('80%')

    expect(page).to have_content('Current Round')
    expect(page).to have_content(round.number + 1)

    expect(page).to have_content('Latest Round')
    expect(page).to have_content(round.number)
  end
end
