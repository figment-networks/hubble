require 'features_helper'

describe 'Prime Admin page' do
  let!(:admin) { create(:admin) }
  let!(:network) { create(:prime_network) }

  it 'signing in and adding a Polkadot chain' do
    visit '/prime/admin'

    expect(page).to have_content('Login')

    fill_in 'email', with: admin.email
    fill_in 'password', with: admin.password

    click_button 'login'

    expect(page).to have_content(network.name.capitalize)
    expect(page).to have_content('Prime Admin')

    find("a[href='/prime/admin/polkadot/new']").click

    expect(page).to have_content('Creating New Polkadot Chain')

    fill_in 'prime_chain_name', with: 'PolkadotChain'
    fill_in 'prime_chain_slug', with: 'test-slug'
    fill_in 'prime_chain_api_url', with: 'http://localhost:9292/polkadot'
    fill_in 'prime_chain_reward_token_remote', with: 'dot'
    fill_in 'prime_chain_reward_token_display', with: 'DOT'
    fill_in 'prime_chain_reward_token_factor', with: '10'

    click_button 'Create Chain'

    expect(page).to have_content('Chain created successfully')
    expect(page).to have_content('PolkadotChain')

    find("a[href='/prime/admin/polkadot/test-slug']", match: :first).click
    click_button 'enable'
    expect(page).to have_content('Chain info has been updated!')
  end
end
