require 'rails_helper'

RSpec.describe Admin::SponsorsController, :type => :controller do

  let(:admin) { create :user }
  before { sign_in admin }

  describe 'index' do
    it 'returns http success' do
      get :index
      expect(response).to be_success
      assigns(:sponsors)
    end
  end

  describe 'new' do
    it 'returns http success' do
      get :new
      expect(response).to be_success
      assigns(:sponsor)
    end
  end

  describe 'edit' do
    let(:sponsor) { create :sponsor }

    it 'returns http success' do
      get :edit, id: sponsor.id
      expect(response).to be_success
      assigns(:sponsor)
    end
  end

  describe 'create' do
    it 'creates a new sponsor record' do
      expect{ post :create, sponsor: attributes_for(:sponsor) }.
        to change(Sponsor, :count).by(1)
    end
  end

  describe 'update' do
    let!(:sponsor) { create :sponsor }

    it 'updates existing sponsor record' do
      put :update, id: sponsor.id, sponsor: { name: 'New name' }
      expect(sponsor.reload.name).to eq 'New name'
    end
  end

  describe 'destroy' do
    let!(:sponsor) { create :sponsor }

    it 'deletes a sponsor record' do
      expect { delete :destroy, id: sponsor }.to change{ Sponsor.count }.by(-1)
    end
  end
end
