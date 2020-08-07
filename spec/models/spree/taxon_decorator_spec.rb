require 'spec_helper'

describe Spree::Taxon do
  describe '.find_by_store_id_and_permalink!' do
    context 'taxon exist in given store' do
      let!(:store)    { create(:store) }
      let!(:taxonomy) { create(:taxonomy, store: store) }
      let!(:taxon)    { create(:taxon, taxonomy: taxonomy) }

      let!(:anotherstore)    { create(:store, name: 'second-test-store') }
      let!(:anothertaxonomy) { create(:taxonomy, store: anotherstore) }
      let!(:anothertaxon)    { create(:taxon, taxonomy: anothertaxonomy) }

      it 'should return a taxon' do
        found_taxon = Spree::Taxon.find_by_store_id_and_permalink!(store.id, taxon.permalink)

        expect(found_taxon).to eq(taxon)
        expect(found_taxon).not_to eq(anothertaxon)
      end
    end

    context 'taxon does not exist in given store' do
      it 'should raise active_record::not_found' do
        expect { Spree::Taxon.find_by_store_id_and_permalink!(1, 'non-existing-permalink') }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'scopes' do
    describe '.by_store' do
      let!(:store)    { create(:store) }
      let!(:taxonomy) { create(:taxonomy, store: store) }
      let!(:taxon)    { create(:taxon, taxonomy: taxonomy) }
      let!(:taxon2)   { create(:taxon) }

      it 'correctly finds taxon by store' do
        taxon_by_store = Spree::Taxon.by_store(store)

        expect(taxon_by_store).to include(taxon)
        expect(taxon_by_store).not_to include(taxon2)
      end
    end
  end
end
