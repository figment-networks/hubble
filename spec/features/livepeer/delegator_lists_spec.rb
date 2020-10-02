require 'features_helper'

feature 'Livepeer Delegator Lists' do
  let!(:user) { create(:user) }
  let!(:chain) { create(:livepeer_chain) }

  let!(:delegator_list) { create(:livepeer_delegator_list, user: user, chain: chain) }

  scenario 'visiting the delegator lists page' do
    visit "/livepeer/chains/#{chain.slug}"

    click_link 'Delegator Lists'

    expect(page.current_path).to eq('/login')
  end

  context 'as a signed in user', :vcr do
    before { log_in(user) }

    scenario 'visiting the delegator lists page' do
      visit "/livepeer/chains/#{chain.slug}"

      click_link 'Delegator Lists'

      expect(page).to have_content(delegator_list.id)
      expect(page).to have_content(delegator_list.name)
    end

    scenario 'creating a delegator list' do
      visit "/livepeer/chains/#{chain.slug}/delegator_lists"

      find('a .fa-plus').click

      expect(page).to have_content('Create a delegator list')

      fill_in 'delegator_list[name]', with: 'Example Delegator List'
      fill_in 'delegator_list[addresses][]', with: 'D58F371A5F0E8922F645C8E6633F57EBACB85E53'

      click_button 'Submit'

      expect(page.current_path).to eq("/livepeer/chains/#{chain.slug}/delegator_lists")

      expect(page).to have_content('Example Delegator List')
      expect(page).to have_content('1')
      expect(page).to have_content('NOT SUBSCRIBED')
    end

    scenario 'editing a delegator list' do
      visit "/livepeer/chains/#{chain.slug}/delegator_lists"

      find('a .fa-pen').click

      expect(page).to have_content('Edit a delegator list')

      fill_in 'Name', with: 'Updated Delegator List'

      click_button 'Add delegator'

      within '.delegators .delegator:last-of-type' do
        fill_in 'delegator_list[addresses][]', with: '93761DAFCA62EF8FFD138A05EBA645C80098E2AD'
      end

      click_button 'Submit'

      expect(page.current_path).to eq("/livepeer/chains/#{chain.slug}/delegator_lists")

      expect(page).to have_content('Updated Delegator List')
      expect(page).to have_content('2')
      expect(page).to have_content('NOT SUBSCRIBED')
    end

    scenario 'deleting a delegator list' do
      visit "/livepeer/chains/#{chain.slug}/delegator_lists"

      accept_alert 'Are you sure?' do
        find('a .fa-trash').click
      end

      expect(page.current_path).to eq("/livepeer/chains/#{chain.slug}/delegator_lists")

      expect(page).to have_no_content(delegator_list.id)
      expect(page).to have_no_content(delegator_list.name)
    end
  end
end
