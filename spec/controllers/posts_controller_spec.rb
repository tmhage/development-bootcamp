require 'rails_helper'

RSpec.describe PostsController, :type => :controller do

  let!(:published_post) { FactoryGirl.create(:post) }
  let!(:unpublished_post) { FactoryGirl.create(:post, unpublished_at: DateTime.now) }

  describe "GET index" do
    before { get :index }

    it "returns http success" do
      expect(response).to be_success
    end

    it "assigns public @posts" do
      expect(assigns(:posts).count).to eq 1
      expect(assigns(:posts)).to_not include unpublished_post
      expect(assigns(:posts)).to include published_post
    end
  end

  describe "GET show" do
    it "returns http success when a post is published" do
      get :show, id: published_post
      expect(response).to be_success
    end

    it "assigns a published @post" do
      get :show, id: published_post
      expect(assigns(:post)).to eq published_post
    end

    it "returns http not found when a post is published" do
      get :show, id: unpublished_post
      expect(response).to be_not_found
    end
  end
end
