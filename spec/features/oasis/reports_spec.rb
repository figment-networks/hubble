require 'features_helper'

describe 'oasis reports' do
  let!(:chain) { create(:oasis_chain, api_url: 'https://localhost:1111') }
  let(:account_id) { 'oasis1qz2weu3fm3vq5ywyx4yfmd5hrjr3j6vxuuwwupvd' }

  it 'visiting New Oasis Report View' do
    visit new_oasis_chain_report_path(chain)

    expect(page).to have_content('Oasis')
    expect(page).to have_content('Generate Report for Account')
  end

  it 'visiting Show Oasis Report View', :vcr do
    visit oasis_chain_report_path(chain, account_id)

    expect(page).to have_content('Oasis')
    expect(page).to have_content('Figment Inc')
    expect(page).to have_content('Export')
    expect(page).to have_content('New Report')
    expect(page).to have_content('Reward')
    expect(page).to have_content('32.151347714')
  end
end
