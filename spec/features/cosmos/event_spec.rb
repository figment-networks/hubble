require 'features_helper'

describe 'cosmos validators' do
  let!(:chain) { create(:cosmos_chain) }
  let!(:validator) { create(:cosmos_validator_synced, chain: chain) }
  let!(:event) { create(:cosmos_event, chainlike: chain, validatorlike: validator) }

  context 'logged out' do
    it 'visiting Cosmos Single Event View as not signed in user' do
      visit "/cosmos/chains/#{chain.slug}/events/#{event.id}"

      expect(page).to have_content(chain.name)
      expect(page).to have_content("Validator Event for #{validator.moniker}")
      expect(page).to have_content('This is the most recent event for this validator')
    end
  end
end
