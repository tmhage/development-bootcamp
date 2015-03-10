require 'rails_helper'

describe DiscountCode do
  describe '.valid' do
    before do
      create_list(:discount_code, 2)
      create_list(:discount_code, 2, valid_until: 1.minute.ago)
    end

    it { expect(DiscountCode.count).to be 4 }
    it { expect(DiscountCode.valid.count).to be 2 }

  end
  describe '#find_by_slug' do
    let!(:code) { create(:discount_code) }
    it { expect(DiscountCode.find_by_slug(code.slug)).to eq code }
  end
end
