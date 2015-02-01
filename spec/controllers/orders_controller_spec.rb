require 'rails_helper'

RSpec.describe OrdersController, :type => :controller do
  describe "POST webhook" do
    let(:order_id) { order.identifier }
    let(:order) { create(:order) }
    let(:payment) { double(status: 'paid', 'paid?' => true) }

    before do
      expect(Order).to receive(:find_by_mollie_payment_id).with(order_id).and_return(order)
      expect(order).to receive(:payment).at_least(:once).and_return payment
      post :webhook, id: order_id
    end

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
