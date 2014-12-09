require 'rails_helper'

RSpec.describe StudentsController, type: :controller do

  describe '#new' do
    it 'returns http success' do
      get :new
      expect(response).to be_success
    end
  end

  describe '#create' do
    let(:student_attributes) { attributes_for :student }

    it 'returns creates a Student' do
      expect_any_instance_of(StudentsController).to receive(:add_to_list)
      expect { post :create, student: student_attributes }.
        to change{ Student.count }.from(0).to(1)
    end

    it 'redirects to the thank you page' do
      expect(post :create, student: student_attributes).
        to redirect_to thanks_student_path(Student.last)
    end
  end
end
