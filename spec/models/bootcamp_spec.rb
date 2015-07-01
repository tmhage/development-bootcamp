require 'rails_helper'

describe Bootcamp do
  let(:bootcamp) { Bootcamp.new }

  describe 'default values for prices' do
    it { expect(bootcamp.community_price).to eq 999 }
    it { expect(bootcamp.normal_price).to eq 1099 }
    it { expect(bootcamp.supporter_price).to eq 1199 }

    context 'when overridden' do
      let(:bootcamp) { Bootcamp.new(community_price: 699) }
      it { expect(bootcamp.community_price).to eq 699 }
      it { expect(bootcamp.normal_price).to eq 1099 }
      it { expect(bootcamp.supporter_price).to eq 1199 }
    end
  end
end
