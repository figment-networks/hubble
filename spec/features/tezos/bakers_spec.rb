require 'features_helper'

def visit_baker_page(id)
  visit "/tezos/bakers/#{id}"
end

feature 'baker details' do
  let!(:chain) { create(:tezos_chain) }
  let(:baker_id) { 'tz2Q7Km98GPzV1JLNpkrQrSo5YUhPfDp6LmA' }
  let(:user) { create(:user) }

  scenario 'visit as not signed in user and try to subscribe', :vcr do
    visit_baker_page(baker_id)
    expect(page).to have_content(baker_id)

    click_link('Subscribe')
    expect(page.current_path).to eq('/login')
  end

  scenario 'sign in and subscribe to baker', :vcr do
    log_in(user)

    visit_baker_page(baker_id)
    click_link('Subscribe')
    fill_in 'telegram_account[username]', with: 'username'
    click_button 'Save'
    expect(user.subscriptions[0].baker_id).to eq(baker_id)
  end
end
