require 'spec_helper'

describe 'Product Stores', type: :feature, js: true do
  stub_authorization!

  before do
    create(:product)
    create(:store, default_currency: 'USD', name: 'First store')
    create(:store, default_currency: 'USD', name: 'Second store')
    create(:store, default_currency: 'USD', name: 'Marketplace')
    visit spree.admin_products_path

    within_row(1) { click_icon :edit }
  end

  context 'editing product stores' do
    it 'shows stores that match query' do
      fill_in 'Stores', with: 'sto'

      expect(page).to have_content 'First store'
      expect(page).to have_content 'Second store'
      expect(page).not_to have_content 'Marketplace'
    end

    it 'still shows stores that match query' do
      fill_in 'Stores', with: 'place'

      expect(page).not_to have_content 'First store'
      expect(page).not_to have_content 'Second store'
      expect(page).to have_content 'Marketplace'
    end

    it 'updates list of stores that product is assigned to' do
      fill_in 'Stores', with: 'place'

      within('#select2-drop') do
        first('.select2-result').click
      end

      click_button 'Update'

      expect(page).to have_content 'successfully updated'
      expect(page).to have_content 'Marketplace'
    end
  end
end
