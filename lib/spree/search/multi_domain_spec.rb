require 'spec_helper'

describe Spree::Search::MultiDomain do
  describe "#retrieve_products" do
    subject { described_class.new(params).retrieve_products }
    context 'store id is given in params' do
      let(:store) { create(:store) }
      let!(:product1) { create(:product, stores: [store])}
      let!(:product2) { create(:product)}
      let(:params) {{ current_store_id: store.id }}
      it 'returns only products from store with id requested in params' do
        expect(subject).to include(product1)
        expect(subject).not_to include(product2)
      end
    end
  end
end
