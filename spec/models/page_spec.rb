require 'rails_helper'

describe Page do
  let(:page) { create(:page, published: published) }
  let(:published) { false }

  describe '.published' do
    it { expect(Page.published).not_to include(page) }

    context 'when published' do
      let(:published) { true }

      it { expect(Page.published).to include(page) }
    end
  end

  describe '#publish!' do
    it { expect { page.publish! }.to change { page.published? }.from(false).to(true) }
  end

  describe '#unpublish!' do
    let(:published) { true }

    it { expect { page.unpublish! }.to change { page.published? }.from(true).to(false) }
  end
end
