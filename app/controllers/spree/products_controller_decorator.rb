module Spree
  module ProductsControllerDecorator
    def self.prepended(base)
      base.before_action :can_show_product, only: :show
    end

    private

    def can_show_product
      @product ||= Spree::Product.friendly.find(params[:id])
      if @product.stores.empty? || !@product.stores.include?(current_store)
        raise ActiveRecord::RecordNotFound
      end
    end
  end
end

::Spree::ProductsController.prepend(Spree::ProductsControllerDecorator)
