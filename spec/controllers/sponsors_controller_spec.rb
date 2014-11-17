require 'rails_helper'

RSpec.describe SponsorsController, type: :controller do

  describe '#index' do
    it 'returns http success' do
      get :index
      expect(response).to be_success
    end
  end

  describe '#new' do
    it 'returns http success' do
      get :new
      expect(response).to be_success
    end
  end

  describe '#create' do
    let(:sponsor_attributes) { attributes_for :sponsor }

    it 'returns http success' do
      expect { post :create, sponsor: sponsor_attributes }.
        to change{ Sponsor.count }.from(0).to(1)
    end
  end
end
