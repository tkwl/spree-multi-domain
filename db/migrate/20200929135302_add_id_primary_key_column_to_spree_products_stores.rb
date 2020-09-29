class AddIdPrimaryKeyColumnToSpreeProductsStores < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_products_stores, :id, :primary_key
  end
end
