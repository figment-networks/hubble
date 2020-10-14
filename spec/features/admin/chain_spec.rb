require 'features_helper'

describe 'Admin page' do
  let!(:admin) { create(:admin) }

  it 'signing in an adding a Polkadot chain', :vcr do
    visit '/admin'

    expect(page).to have_content('Login')

    fill_in 'email', with: admin.email
    fill_in 'password', with: admin.password

    click_button 'login'

    expect(page).to have_content('Polkadot')
    expect(page).to have_content('Administrators')

    find("a[href='/admin/polkadot/chains/new']").click

    expect(page).to have_content('Creating Polkadot Chain')

    fill_in 'polkadot_chain_name', with: 'Polkadot test name'
    fill_in 'polkadot_chain_slug', with: 'test-slug'
    fill_in 'polkadot_chain_api_url', with: 'http://localhost:9292/polkadot'

    click_button 'Create Chain'

    expect(page).to have_content('Chain created successfully')
    expect(page).to have_content('Polkadot test name')
  end
end
