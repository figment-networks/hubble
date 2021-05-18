require 'features_helper'

describe 'near block page' do
  let(:chain) { create(:near_chain) }
  let(:block) { 30025735 }

  it 'visiting block details', :vcr do
    visit "/near/chains/#{chain.slug}/blocks/#{block}"
    expect(page).to have_content('BUUDuAJMVJuwc7Rk3ERHtog5n1UDYHj6B19JZW1o5Y1N')
    expect(page).to have_content('9vGmeLkXDGvakWgdqnMRp18Jb7K445CKVrDDpRNja4NE')
    expect(page).to have_content('JSON')
    expect(page).to have_content('2021-02-15 @ 22:48 UTC')
  end
end
