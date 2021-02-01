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

    expect(page).to have_content('Orchestrators')

    expect(page).to have_content('FBDDD6ADD2FDE17677875A751695DCB00915F57C')
    expect(page).to have_content('20%')
    expect(page).to have_content('80%')

    expect(page).to have_content('CURRENT ROUND')
    expect(page).to have_content(round.number + 1)

    expect(page).to have_content('LATEST ROUND')
    expect(page).to have_content(round.number)
  end
end
