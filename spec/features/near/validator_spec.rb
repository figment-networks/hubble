require 'features_helper'

describe 'near validator page' do
  let(:chain) { create(:near_chain) }
  let(:validator) { 'magic.poolv1.near' }

  it 'visiting validator details', :vcr do
    visit "/near/chains/#{chain.slug}/validators/#{validator}"
    expect(page).to have_content('9,013,070.29')
    expect(page).to have_content('f502bd4a08fcc021a03029e304af1b029b4b2fc3.lockup.near')
    expect(page).to have_content('Epoch Performance')
    expect(page).to have_content('👞 magic.poolv1.near was kicked - reason: Not enough blocks')
  end
end
