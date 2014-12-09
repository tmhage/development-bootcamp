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

    it 'returns creates a Sponsor' do
      expect_any_instance_of(SponsorsController).to receive(:add_to_list)
      expect { post :create, sponsor: sponsor_attributes }.
        to change{ Sponsor.count }.from(0).to(1)
    end

    it 'redirects to the thank you page' do
      expect(post :create, sponsor: sponsor_attributes).
        to redirect_to thanks_sponsor_path(Sponsor.last)
    end
  end
end
