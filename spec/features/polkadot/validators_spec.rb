require 'features_helper'

feature 'polkadot validators' do
  let(:chain) { create(:polkadot_chain) }

  scenario 'visiting list of validators', :vcr do
    visit "/polkadot/chains/#{chain.slug}"

    expect(page).to have_content("Polkadot")
    expect(page).to have_content("Total stake")
    expect(page).to have_content("Current Block")
    expect(page).to have_content("DragonStake")
    expect(page).to have_content("D8BfryaM5xN62UuKUpLK5zbZEUSBtA76yP9...")
  end
end
