require "features_helper"

feature "mina transactions", :vcr do
  let(:chain) { create :mina_chain }

  before do
    visit mina_chain_transactions_path(chain)
  end

  it "displays transaction search" do
    expect(page).to have_text "Transaction Search"
    expect(page).to have_text "Filter Transactions"
    expect(page).to have_text "Search Results"
    expect(page).to have_link "Summary", href: mina_chain_path(chain)

    within ".transactions-search-form" do
      expect(page).to have_text "Account"
      expect(page).to have_text "Snark Fee"
      expect(page).to have_text "Payment"
      expect(page).to have_text "Fee Transfer"
      expect(page).to have_text "Start Date"
      expect(page).to have_text "Tx Memo"
    end

    within ".transactions-search-results" do
      expect(page.all("tbody > tr").size).to eq 25
    end
  end

  context "search" do
    before do
      fill_in "Tx Memo", with: "E4YgzwkKzKGy6M6Ro79DAPfCAtnehgfEQ4dwz6XPQTRq5wenxdPk3"
      click_on "Search"
    end

    it "displays search results" do
      within ".transactions-search-results" do
        expect(page.all("tbody > tr").size).to eq 2
        expect(page).to have_text "Payment"
        expect(page).to have_text "E4YgzwkKzKGy6M6Ro79DAPfCAtnehgfEQ4dwz6XPQTRq5wenxdPk3"
        expect(page).to have_link "details"
      end
    end

    it "allows to reset the filter" do
      expect { click_on "Reset Filters" }.
        to change { page.find("#search_memo").value }.
          from("E4YgzwkKzKGy6M6Ro79DAPfCAtnehgfEQ4dwz6XPQTRq5wenxdPk3").to("")
    end

    it "redirects to the transaction page" do
      within ".transactions-search-results" do
        within page.find("tbody > tr:first-child") do
          click_on "details"
          expect(page.current_path).to match "/mina/chains/#{chain.slug}/transactions/CkpZYwZYxj8uwsEmT4MBxrHuuAtPfwV31k9bj1P12wgyRFBaoWhuC"
        end
      end
    end
  end

  context "empty search" do
    before do
      fill_in "Tx Memo", with: "something that does not exist"
      click_on "Search"
    end

    it "displays empty search results" do
      within ".transactions-search-results" do
        expect(page).to have_text "No transactions found"
      end
    end
  end

  context "bad search" do
    before do
      visit mina_chain_transactions_path(chain, start_time: "invalid")
    end

    it "displays an error" do
      expect(page).to have_text "Search request failed: start time is invalid"
    end
  end
end
