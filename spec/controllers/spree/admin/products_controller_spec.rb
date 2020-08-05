require 'spec_helper'

describe Spree::Admin::ProductsController do
  stub_authorization!

  let!(:test_store) { create(:store, code: 'test_store', default: true) }

  before do
    Spree::Admin::ProductsController.view_paths = [
      ActionView::FixtureResolver.new(
        "spree/layouts/#{test_store.code}/admin.html.erb" => 'Test store layout <%= yield %>',
        'spree/admin/products/index.html.erb' => 'Admin products index page'
      )
    ]
  end

  describe 'on :index' do
    it 'renders index' do
      get :index

      expect(response).to have_http_status(200)
    end
  end

  describe 'on a PUT to :update' do
    let!(:product) { create(:product) }
    let!(:store)   { create(:store) }

    describe 'when no stores are selected' do
      it 'clears stores if they previously existed' do
        product.stores << store

        put :update, params: {
          id: product.to_param,
          product: {
            name: product.name,
            store_ids: ''
          }
        }

        expect(product.reload.store_ids).to be_empty
      end
    end

    describe 'when a store is selected' do
      it 'clears stores' do
        put :update, params: {
          id: product.to_param,
          product: {
            name: product.name,
            store_ids: store.id
          }
        }

        expect(product.reload.store_ids).to include(store.id)
      end
    end

    describe 'when multiple stores are selected' do
      it 'clears stores' do
        stores = create_list(:store, 3)
        store_ids = stores.map(&:id)

        put :update, params: {
          id: product.to_param,
          product: {
            name: product.name,
            store_ids: store_ids.join(',')
          }
        }

        expect(product.reload.store_ids).to eq(store_ids)
      end
    end
  end
end
