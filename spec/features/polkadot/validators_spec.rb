require 'features_helper'

describe 'polkadot validators' do
  let(:chain) { create(:polkadot_chain) }

  it 'visiting list of validators', :vcr do
    visit "/polkadot/chains/#{chain.slug}"

    expect(page).to have_content('Polkadot')
    expect(page).to have_content('TOTAL STAKE')
    expect(page).to have_content('CURRENT BLOCK')
    # TODO: fix when full_name becomes available in indexer
    # expect(page).to have_content('DragonStake')
    expect(page).to have_content('153RWxqZyAWBM2brLkBEkYmyVyf5aMqGHew...')

    click_on('153RWxqZyAWBM2brLkBEkYmyVyf5aMqGHew...')

    expect(page).to have_content('153RWxqZyAWBM2brLkBEkYmyVyf5aMqGHewbvG3jqENyCKyC')
    expect(page).to have_content('TOTAL STAKE HISTORY')
    expect(page).to have_content('UPTIME HISTORY')
    expect(page).to have_content('1020')
    expect(page).to have_content('August 22, 2020 at 15:36 UTC')
    expect(page).to have_content('Event History')
    expect(page).to have_content('left delegator set')
    expect(page).to have_content('2721888')
  end
end
