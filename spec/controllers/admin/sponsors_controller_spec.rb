require 'rails_helper'

RSpec.describe Admin::SponsorsController, :type => :controller do

  let(:admin) { create :user }
  before { sign_in admin }

  describe 'index' do
    before { get :index }

    it 'returns http success' do
      expect(response).to be_success
    end

    it 'returns http success' do
      expect(assigns(:sponsors)).to eq(Sponsor.all)
    end
  end
end
