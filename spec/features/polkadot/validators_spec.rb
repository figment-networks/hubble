require 'features_helper'

describe 'polkadot validators' do
  let(:chain) { create(:polkadot_chain) }

  it 'visiting list of validators', :vcr do
    visit "/polkadot/chains/#{chain.slug}"

    expect(page).to have_content('Polkadot')
    expect(page).to have_content('Total stake')
    expect(page).to have_content('Current Block')
    expect(page).to have_content('DragonStake')
    expect(page).to have_content('D8BfryaM5xN62UuKUpLK5zbZEUSBtA76yP9...')

    click_on('DragonStake')

    expect(page).to have_content('DSpbbk6HKKyS78c4KDLSxCetqbwnsemv2iocVXwNe2FAvWC')
    expect(page).to have_content('Total Stake History')
    expect(page).to have_content('Uptime History')
    expect(page).to have_content('23,000.766')
    expect(page).to have_content('320')
  end
end
