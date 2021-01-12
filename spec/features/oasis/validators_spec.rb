require 'features_helper'

def visit_validator_page(chain_slug, validator_id)
  visit "/oasis/chains/#{chain_slug}/validators/#{validator_id}"
end

describe 'oasis validators' do
  let!(:chain) { create(:oasis_chain, api_url: 'http://localhost:1111') }
  let(:validator_id) { 'oasis1qz72lvk2jchk0fjrz7u2swpazj3t5p0edsdv7sf8' }
  let(:user) { create(:user) }

  context 'logged out' do
    it 'visiting Oasis Validators View as not signed in user', :vcr do
      visit_validator_page(chain.slug, validator_id)

      expect(page).to have_content(validator_id)
      expect(page).to have_content('ENTITY ID')
      expect(page).to have_content('VOTING POWER HISTORY')
      expect(page).to have_content('CURRENT VOTING POWER')
      expect(page).to have_content('Blocks')
      expect(page).to have_content('LIFETIME')
      expect(page).to have_content('UPTIME HISTORY')
      expect(page).to have_content('Event History')
      expect(page).to have_content('1015800')
      expect(page).to have_content('Added to active set')
      expect(page).to have_content('Delegations')
      expect(page).to have_content('69,485,000')
    end
  end

  context 'logged in' do
    it 'visiting Oasis Validators View as signed in user', :vcr do
      log_in(user)
      VCR.use_cassette('oasis_validators/logged_in/visiting_Oasis_Validators_View_as_signed_in_user') do
        visit_validator_page(chain.slug, validator_id)
        expect(page).to have_content('Subscribe to Alerts')
      end
    end
  end
end
