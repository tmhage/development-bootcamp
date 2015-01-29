require 'rails_helper'

RSpec.describe OrdersController, :type => :controller do
  describe "POST webhook" do
    let(:order_id) { 'foobar' }
    before { post :webhook, id: order_id }

    it "returns http success" do
      expect(response).to be_success
    end

    it "renders 'OK'" do
      expect(response.body).to eq 'OK'
    end

    context "existing order" do
      let(:order_id) { order.mollie_payment_id }
      let!(:order) { create :order_step_payment }

      it "assigns @order" do
        expect(assigns(:order)).to eq order
      end
    end
  end
end
