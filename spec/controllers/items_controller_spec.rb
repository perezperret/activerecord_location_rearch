require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'sets the collection up for the view' do
      get :index
      expect(assigns(:items)).to eq(Item.all)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end

    describe 'with given location params' do
      let(:new_york) { create :geo_location, :new_york }
      let(:los_angeles) { create :geo_location, :los_angeles }
      let(:philly) { create :geo_location, :philly }

      before(:each) do
        create_list :item, 5, store: create(:store, geo_location: new_york)
        create_list :item, 5, store: create(:store, geo_location: los_angeles)
      end

      it 'filters the collection by location' do
        get :index, params: { geo_location_id: philly.id, distance: 100 }
        expect(assigns(:items).map(&:id)).to eq(Item.near(philly, 100).map(&:id))
      end
    end
  end
end
