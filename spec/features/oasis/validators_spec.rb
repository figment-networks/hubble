require 'features_helper'

def visit_validator_page(chain_slug, validator_id)
  visit "/oasis/chains/#{chain_slug}/validators/#{validator_id}"
end

describe 'oasis validators' do
  let!(:chain) { create(:oasis_chain, api_url: 'https://localhost:1111') }
  let(:validator_id) { 'oasis1qzsp62l07fqsxgdeqszwz8hm34hhwem9ny73qnpr' }
  let(:user) { create(:user) }

  context 'logged out' do
    it 'visiting Oasis Validators View as not signed in user', :vcr do
      visit_validator_page(chain.slug, validator_id)

      expect(page).to have_content('Oasis')
      expect(page).to have_content(validator_id)
      expect(page).to have_content('Entity ID')
      expect(page).to have_content('Voting Power History')
      expect(page).to have_content('Current Voting Power')
      expect(page).to have_content('Blocks')
      expect(page).to have_content('Lifetime')
      expect(page).to have_content('Uptime History')
      expect(page).to have_content('Event History')
      expect(page).to have_content('Voting power increased at block 90844')
      expect(page).to have_content('Added to active set at block 5100')
      expect(page).to have_content('Removed from active set at block 1199')
      expect(page).to have_content('Removed from active set at block 1199')
      expect(page).to have_content('Delegations')
      expect(page).to have_content('399.79')
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
