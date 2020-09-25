require 'spec_helper'

describe Spree::Promotion::Rules::Store, type: :model do
  let(:rule) { subject }

  context '#elegible?(order)' do
    let(:order) { create :order_with_line_items }

    context 'when it receives two arguments' do
      it 'it does not raise an error' do
        expect { rule.eligible?(order, true) }.not_to raise_error(ArgumentError)
      end
    end

    context 'when no stores were added' do
      it 'is eligible' do
        expect(rule).to be_eligible(order)
      end
    end

    context 'when stores were added' do
      let(:store) { create(:store, name: 'First Store') }
      let(:store2) { create(:store, name: 'Second Store') }

      before do
        rule.stores << store << store2
      end

      context 'and order is from a different store' do
        it 'is not eligible' do
          expect(rule).not_to be_eligible(order)
        end
      end

      context 'and order is from one of those stores' do
        before do
          order.update(store: store2)
        end

        it 'is eligible' do
          expect(rule).to be_eligible(order)
        end
      end
    end
  end
end
