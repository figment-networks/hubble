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
    expect(page.current_path).to eq('/users/new')
  end
end
