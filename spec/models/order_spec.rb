require 'rails_helper'

RSpec.describe Order, :type => :model do
  let(:order) { build_stubbed(:order) }

  describe '#to_param' do
    it { expect(order.to_param).to eq order.identifier }
  end

  describe '#current_step=' do
    context 'when set to an existing step' do
      let(:set_step) { 'confirmation' }
      before { order.current_step = set_step }
      it { expect(order.current_step).to eq set_step }
    end

    context 'when passed a non-existing step' do
      it 'should raise an ArgumentError' do
        expect { order.current_step = 'foobar' }.to raise_error ArgumentError
      end
    end
  end

  describe '#current_step' do
    it { expect(order.current_step).to eq order.steps.first }

    context 'when set' do
      let(:set_step) { 'confirmation' }
      before { order.current_step = set_step }
      it { expect(order.current_step).to eq set_step }
    end
  end

  describe '#steps' do
    let(:num_students) { 1 }
    before do
      allow(order).
        to receive(:cart_sum_tickets).
        and_return(num_students)
    end
    it { expect(order.steps).to eq %w(tickets details students-0 confirmation) }

    context 'with multiple students' do
      let(:num_students) { 4 }
      it { expect(order.steps).to eq %w(tickets details students-0 students-1 students-2 students-3 confirmation) }
    end
  end

  describe '#next_step' do
    it { expect(order.next_step).to eq 'details' }

    context 'dynamicly generated student steps' do
      before do
        allow(order).
          to receive(:cart_sum_tickets).
          and_return(2)

        order.current_step = 'students-0'
      end

      it { expect(order.next_step).to eq 'students-1' }
    end

    context 'last step' do
      before { order.current_step = order.steps.last }
      it { expect(order.next_step).to eq order.steps.last }
    end
  end

  describe '#previous_step' do
    before { order.current_step = 'details' }
    it { expect(order.previous_step).to eq 'tickets' }

    context 'dynamicly generated student steps' do
      before do
        allow(order).
          to receive(:cart_sum_tickets).
          and_return(2)

        order.current_step = 'students-1'
      end

      it { expect(order.previous_step).to eq 'students-0' }
    end

    context 'first step' do
      before { order.current_step = order.steps.first }
      it { expect(order.previous_step).to eq order.steps.first }
    end
  end

  describe '#first_step?' do
    it { expect(order.first_step?).to be true }

    context 'later step' do
      before { order.current_step = 'details' }
      it { expect(order.first_step?).to be false }
    end
  end

  describe '#last_step?' do
    it { expect(order.last_step?).to be false }

    context 'last step' do
      before { order.current_step = order.steps.last }
      it { expect(order.last_step?).to be true }
    end
  end

  describe '#creditcard_fee' do
    it 'should be 2.9% of the cart sum total and rounded by 2 decimals' do
      expect(order.creditcard_fee).to eq((0.029 * order.cart_sum_total).round(2))
    end
  end

  describe '#creditcard_total' do
    it 'should be the cart sum total plus the creditcard fee, in cents' do
      expect(order).to receive(:creditcard_fee).and_return(10)
      expect(order.creditcard_total).to eq(70900)
    end
  end

  describe 'discount code' do
    let(:order) { build(:order, promo_code: promo_code, cart: cart) }
    let(:cart) { { community: 1, normal: 0, supporter: 0 } }

    before { order.validate_discount_code }

    describe 'validation' do
      context 'is valid' do
        let(:discount_code) { create(:discount_code) }
        let(:promo_code) { discount_code.code }
        it { expect(order.discount_code).to eq discount_code }
        it { expect(order.valid?).to be true }

        context 'but expired' do
          let(:discount_code) { create(:discount_code, valid_until: 1.minute.ago) }
          it { expect(order.discount_code).to be nil }
          it { expect(order.valid?).to be false }
        end
      end

      context 'is invalid' do
        let(:promo_code) { 'random user input' }
        it { expect(order.discount_code).to be nil }
        it { expect(order.valid?).to be false }
      end
    end

    describe 'student_discount_code_percentages' do
      let(:discount_code) { create(:discount_code, discount_percentage: 10) }
      let(:promo_code) { discount_code.code }
      it { expect(order.student_discount_code_percentages).to eq [10] }

      context 'when one of the students has multiple orders on their discount code' do
        let(:cart) { { community: 1, normal: 1, supporter: 1 } }
        let!(:students) { create_list(:student, 3) }
        let(:discount_code) { students.first.current_discount_code }
        let(:promo_code) { discount_code.code }
        let(:current_order) { create(:order, promo_code: promo_code, cart: cart) }
        let!(:previous_orders) { create_list(:order, 2, promo_code: promo_code) }
        before { current_order.student_ids = students.map(&:id) }
        it { expect(current_order.student_discount_code_percentages).to eq [20, 10, 10] }
        it { expect(current_order.cart_discount.round(2)).to eq((current_order.ticket_prices[:normal]*0.2+current_order.ticket_prices[:supporter]*0.1).round(2)) }
      end
    end

    describe 'order price' do
      let(:discount_code) { create(:discount_code, discount_percentage: 10) }
      let(:promo_code) { discount_code.code }
      it { expect(order.cart_sum_total).to eq order.ticket_prices[:community].round(2) }

      context 'when ordering non-community tickets' do
        let(:cart) { { community: 0, normal: 1, supporter: 0 } }

        it { expect(order.cart_sum_total).to eq (0.9 * order.ticket_prices[:normal]).round(2) }

        context 'different percentage' do
          let(:discount_code) { create(:discount_code, discount_percentage: 20) }
          it { expect(order.cart_sum_total).to eq (0.8 * order.ticket_prices[:normal]).round(2) }
        end

        context 'supporter tickets' do
          let(:cart) { { community: 0, normal: 0, supporter: 1 } }

          it { expect(order.cart_sum_total).to eq (0.9 * order.ticket_prices[:supporter]).round(2) }
        end
      end
    end

    describe '#sold_out?' do
      let(:bootcamp) { create(:bootcamp) }
      let(:order) { build_stubbed(:order, bootcamp: bootcamp) }

      describe 'validations' do
        it { expect(order).to be_valid }

        context 'when bootcamp is sold out' do
          let(:bootcamp) { create(:bootcamp, sold_out: true) }
          it { expect(order).not_to be_valid }
        end
      end
    end
  end
end
