require 'rails_helper'

RSpec.describe Admin::PostsController, :type => :controller do
  context "logged in" do
    include LoggedInAsUser

    let(:_post) { FactoryGirl.create :post }

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

    describe "POST create" do
      it "returns http success" do
        expect {
          post :create, post: FactoryGirl.attributes_for(:post)
        }.to change(Post, :count).by(1)
      end
    end

    describe "GET edit" do
      it "returns http success" do
        get :edit, id: _post, post: _post
        expect(response).to be_success
      end
    end

    describe "PUT update" do
      let(:updated) { FactoryGirl.attributes_for(:post) }
      it "updates the post" do
        put :update, id: _post, post: { title: updated[:title] }
        expect(_post.reload.title).to eq updated[:title]
      end
    end

    describe "DELETE destroy" do
      it "returns http success" do
        _post
        expect {
          delete :destroy, id: _post
        }.to change{ Post.count }.by(-1)
      end
    end
  end
end
