require 'rails_helper'

RSpec.describe Admin::LessonsController, type: :controller do

  let(:admin) { create :user }
  before { sign_in admin }

  describe 'index' do
    it 'returns http success' do
      get :index
      expect(response).to be_success
      assigns(:lessons)
    end
  end

  describe 'new' do
    it 'returns http success' do
      get :new
      expect(response).to be_success
      assigns(:lesson)
    end
  end

  describe 'edit' do
    let(:lesson) { create :lesson }

    it 'returns http success' do
      get :edit, id: lesson.slug
      expect(response).to be_success
      assigns(:lesson)
    end
  end

  describe 'create' do
    it 'creates a new lesson record' do
      expect{ post :create, lesson: attributes_for(:lesson) }.
        to change(Lesson, :count).by(1)
    end
  end

  describe 'update' do
    let!(:lesson) { create :lesson }

    it 'updates existing lesson record' do
      put :update, id: lesson.slug, lesson: { title: 'New title' }
      expect(lesson.reload.title).to eq 'New title'
    end
  end

  describe 'destroy' do
    let!(:lesson) { create :lesson }

    it 'deletes a lesson record' do
      expect { delete :destroy, id: lesson }.to change{ Lesson.count }.by(-1)
    end
  end
end
