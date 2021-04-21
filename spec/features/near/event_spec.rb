require 'features_helper'

describe 'near events page' do
  let(:chain) { create(:near_chain) }

  it 'visiting events page', :vcr do
    visit "/near/chains/#{chain.slug}/events"
    expect(page).to have_content('👞 cryptium.poolv1.near was kicked - reason: Not enough blocks')
    expect(page).to have_content('32370653')
    expect(page).to have_content('March 13, 2021 at 13:12')
  end
end
