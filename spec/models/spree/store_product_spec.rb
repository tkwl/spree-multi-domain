require 'spec_helper'

describe Spree::StoreProduct do
  let!(:store)    { create(:store) }
  let!(:store_2)  { create(:store) }
  let!(:product)  { create(:product) }

  context 'assigning store' do
    it 'should touch product' do
      expect { product.stores << store }.to change { product.reload.updated_at }
    end

    it 'should increase StoreProduct count' do
      expect { product.stores << store }.to change { Spree::StoreProduct.count }.from(0).to(1)
    end
  end

  context 'unassigign store' do
    before { product.stores << store }

    it 'should touch product' do
      expect { product.stores.destroy(store) }.to change { product.reload.updated_at }
    end

    it 'should decrease StoreProduct count' do
      expect { product.stores.destroy(store) }.to change { Spree::StoreProduct.count }.from(1).to(0)
    end

    it 'should not remove store' do
      expect { product.stores.destroy(store) }.not_to change { Spree::Store.count }
    end
  end
end
