require 'rails_helper'

RSpec.describe Admin::PagesController, :type => :controller do
  context "logged in" do
    include LoggedInAsUser

    let(:_page) { FactoryGirl.create :page }

    describe "GET index" do
      it "returns http success" do
        get :index
        expect(response).to be_success
      end
    end

    describe "GET new" do
      it "returns http success" do
        get :new
        expect(response).to be_success
      end
    end

    describe "page create" do
      it "returns http success" do
        expect {
          post :create, page: FactoryGirl.attributes_for(:page)
        }.to change(Page, :count).by(1)
      end
    end

    describe "GET edit" do
      it "returns http success" do
        get :edit, id: _page, page: _page
        expect(response).to be_success
      end
    end

    describe "PUT update" do
      let(:updated) { FactoryGirl.attributes_for(:page) }
      it "updates the page" do
        put :update, id: _page, page: { title: updated[:title] }
        expect(_page.reload.title).to eq updated[:title]
      end
    end

    describe "DELETE destroy" do
      it "returns http success" do
        _page
        expect {
          delete :destroy, id: _page
        }.to change{ Page.count }.by(-1)
      end
    end
  end
end
