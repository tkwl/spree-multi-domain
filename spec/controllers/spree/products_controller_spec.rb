require 'spec_helper'

describe Spree::ProductsController do
  let!(:product) { create(:product) }
  let!(:store)   { create(:store, code: 'test_store') }

  before do
    Spree::ProductsController.view_paths = [
      ActionView::FixtureResolver.new(
        "spree/layouts/#{store.code}/spree_application.html.erb" => 'Test store layout <%= yield %>',
        'spree/products/show.html.erb' => 'Products show page'
      )
    ]
  end

  describe 'on :show to a product without any stores' do
    it 'should raise ActiveRecord::RecordNotFound' do
      expect { get :show, params: { id: product.to_param } }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  # Regression test for #75
  describe 'on :show to a product in the wrong store' do
    let!(:store_2) { create(:store) }
    before { product.stores << store }

    it 'should raise ActiveRecord::RecordNotFound' do
      allow(controller).to receive(:current_store).and_return(store_2)

      expect { get :show, params: { id: product.to_param } }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'on :show to a product w/ store' do
    before { product.stores << store }

    it 'should return 200' do
      allow(controller).to receive(:current_store).and_return(store)
      get :show, params: { id: product.to_param }

      expect(response).to have_http_status(200)
    end
  end
end
