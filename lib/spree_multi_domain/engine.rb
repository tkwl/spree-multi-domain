module SpreeMultiDomain
  class Engine < Rails::Engine
    engine_name 'spree_multi_domain'

    config.autoload_paths += %W[#{config.root}/lib]

    def self.activate
      %w[app lib].each do |dir|
        Dir.glob(File.join(File.dirname(__FILE__), "../../#{dir}/**/*_decorator*.rb")).sort.each do |c|
          Rails.application.config.cache_classes ? require(c) : load(c)
        end
      end

      Spree::Config.searcher_class = Spree::Search::MultiDomain
      ApplicationController.include SpreeMultiDomain::MultiDomainHelpers
    end

    config.to_prepare(&method(:activate).to_proc)

    initializer 'templates with dynamic layouts' do
      ActionView::TemplateRenderer.prepend(
        Module.new do
          def render_template(view, template, layout_name, locals)
            store_layout = if layout_name.is_a?(String)
                             layout_name.gsub('layouts/', "layouts/#{view.current_store.code}/")
                           else
                             layout_name.call.try(:gsub, 'layouts/', "layouts/#{view.current_store.code}/")
                           end

            super(view, template, store_layout, locals)
          end
        end
      )
    end

    initializer 'spree.promo.register.promotions.rules' do |app|
      app.config.spree.promotions.rules << Spree::Promotion::Rules::Store
    end
  end
end
