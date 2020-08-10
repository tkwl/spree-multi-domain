module Spree
  module Admin
    module ProductsControllerDecorator
      def self.prepended(base)
        base.before_action :find_stores, only: [:update]
      end

      private

      def find_stores
        store_ids = params[:product][:store_ids]
        if store_ids.present?
          params[:product][:store_ids] = store_ids.split(',')
        end
      end
    end
  end
end

::Spree::Admin::ProductsController.prepend(Spree::Admin::ProductsControllerDecorator)
