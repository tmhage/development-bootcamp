require 'rails_helper'

RSpec.describe Admin::WorkshopsController, type: :controller do

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
      get :edit, id: workshop.slug
      expect(response).to be_success
      assigns(:workshop)
    end
  end

  describe 'show' do
    let(:workshop) { create :workshop }

    it 'returns http success' do
      get :show, id: workshop.slug
      expect(response).to be_success
      assigns(:workshop)
    end
  end

  describe 'create' do
    it 'creates a new workshop record' do
      expect{ post :create, workshop: attributes_for(:workshop) }.
        to change(Workshop, :count).by(1)
    end
  end

  describe 'update' do
    let!(:workshop) { create :workshop }

    it 'updates existing workshop record' do
      put :update, id: workshop.slug, workshop: { title: 'New title' }
      expect(workshop.reload.title).to eq 'New title'
    end
  end

  describe 'destroy' do
    let!(:workshop) { create :workshop }

    it 'deletes a workshop record' do
      expect { delete :destroy, id: workshop }.to change{ Workshop.count }.by(-1)
    end
  end
end
