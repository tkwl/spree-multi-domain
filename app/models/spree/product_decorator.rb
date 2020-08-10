module Spree
  module ProductDecorator
    def self.prepended(base)
      base.has_and_belongs_to_many :stores, join_table: 'spree_products_stores'
      base.scope :by_store, ->(store) { joins(:stores).where(spree_products_stores: { store_id: store.id }) }
    end
  end
end

::Spree::Product.prepend(Spree::ProductDecorator)
