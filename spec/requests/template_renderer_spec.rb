require 'spec_helper'

describe 'Template renderer with dynamic layouts' do
  let!(:my_store) { create(:store, code: 'my_store', default: true, url: 'mystore.example.com') }

  before do
    ApplicationController.view_paths = [
      ActionView::FixtureResolver.new(
        'spree/layouts/spree_application.html.erb' => 'Default layout <%= yield %>',
        "spree/layouts/#{my_store.code}/spree_application.html.erb" => 'Store layout <%= yield %>',
        'application/index.html.erb' => 'hello'
      )
    ]
  end

  it 'should render the layout corresponding to the current store' do
    get 'http://mystore.example.com'

    expect(response.body).to eq('Store layout hello')
  end
end
