require 'features_helper'

describe 'polkadot validators' do
  let(:chain) { create(:polkadot_chain) }

  it 'visiting list of validators', :vcr do
    visit "/polkadot/chains/#{chain.slug}"

    expect(page).to have_content('Polkadot')
    expect(page).to have_content('Total stake')
    expect(page).to have_content('Current Block')
    # TODO: fix when full_name becomes available in indexer
    # expect(page).to have_content('DragonStake')
    expect(page).to have_content('153RWxqZyAWBM2brLkBEkYmyVyf5aMqGHew...')

    click_on('153RWxqZyAWBM2brLkBEkYmyVyf5aMqGHew...')

    expect(page).to have_content('153RWxqZyAWBM2brLkBEkYmyVyf5aMqGHewbvG3jqENyCKyC')
    expect(page).to have_content('Total Stake History')
    expect(page).to have_content('Uptime History')
    expect(page).to have_content('5,380,001')
  end
end
