require 'spec_helper'

describe 'Template renderer with dynamic layouts' do
  let!(:my_store) { create(:store, code: 'my_store', default: true, url: 'mystore.example.com') }
  let!(:other_store) { create(:store, code: 'other_store', url: 'other.example.com') }

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

  it 'renders default spree layout if current store layout is missing' do
    get 'http://other.example.com'

    expect(response.body).to eq('Default layout hello')
  end
end
