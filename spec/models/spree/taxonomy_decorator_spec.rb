require 'spec_helper'

describe Spree::Taxonomy do
  let!(:store)     { create(:store) }
  let!(:taxonomy)  { create(:taxonomy, store: store) }
  let!(:taxonomy2) { create(:taxonomy) }

  it 'correctly finds taxonomy by store' do
    taxonomy_by_store = Spree::Taxonomy.by_store(store)

    expect(taxonomy_by_store).to include(taxonomy)
    expect(taxonomy_by_store).not_to include(taxonomy2)
  end
end
