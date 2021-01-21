require 'features_helper'

describe 'celo validator details' do
  let(:chain) { create(:celo_chain) }
  let(:address) { '0xDD1F519F63423045F526b8c83edC0eB4BA6434a4' }

  it 'visiting validator details', :vcr do
    visit "/celo/chains/#{chain.slug}/validators/#{address}"

    expect(page).to have_content('SCORE')
    expect(page).to have_content('AVERAGE UPTIME')
    expect(page).to have_content('LIFETIME')
    expect(page).to have_content('COMMISSION')
    expect(page).to have_content('SCORES HISTORY')
    expect(page).to have_content('UPTIME HISTORY')
  end
end
