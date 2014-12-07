require 'rails_helper'

RSpec.describe Admin::WorkshopController, :type => :controller do

  let(:admin) { create :user }
  before { sign_in admin }

  describe 'index' do
    it 'returns http success' do
      get :index
      expect(response).to be_success
      assigns(:workshops)
    end
  end

  describe 'new' do
    it 'returns http success' do
      get :new
      expect(response).to be_success
      assigns(:workshop)
    end
  end

  describe 'edit' do
    let(:workshop) { create :workshop }

    it 'returns http success' do
      get :edit, id: workshop.id
      expect(response).to be_success
      assigns(:workshop)
    end
  end

end
