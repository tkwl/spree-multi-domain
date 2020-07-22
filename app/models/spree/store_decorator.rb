module Spree
  module StoreDecorator
    def self.prepended(base)
      base.has_and_belongs_to_many :products, join_table: 'spree_products_stores'
      base.has_many :taxonomies
      base.has_and_belongs_to_many :promotion_rules, class_name: 'Spree::Promotion::Rules::Store', join_table: 'spree_promotion_rules_stores', association_foreign_key: 'promotion_rule_id'
    end
  end
end

::Spree::Store.prepend(Spree::StoreDecorator)
