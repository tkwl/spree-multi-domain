require 'spec_helper'

describe 'Template renderer with dynamic layouts' do
  before do
    ApplicationController.view_paths = [
      ActionView::FixtureResolver.new(
        'spree/layouts/spree_application.html.erb'             => 'Default layout <%= yield %>',
        'spree/layouts/my_store/spree_application.html.erb'    => 'Store layout <%= yield %>',
        'application/index.html.erb'                           => 'hello'
      )
    ]
  end

  it 'should render the layout corresponding to the current store' do
    create(:store, code: 'my_store', default: true)
    get 'http://www.example.com'

    expect(response.body).to eq('Store layout hello')
  end

  it 'should fall back to the default layout if none are found for the current store' do
    skip if Spree.version.to_f > 3.7 # this doesn't make sense for Spree 4.x as there is always a current store
    allow(ApplicationController).to receive(:current_store).and_return(nil)
    get 'http://www.example.com'

    expect(response.body).to eq('Default layout hello')
  end
end
