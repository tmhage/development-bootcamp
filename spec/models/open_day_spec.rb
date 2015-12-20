require 'rails_helper'

describe OpenDay do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_presence_of(:starts_at) }
    it { is_expected.to validate_presence_of(:description_en) }
    it { is_expected.to validate_presence_of(:description_nl) }
    it { is_expected.to validate_presence_of(:facebook_event_url) }
  end

  describe 'upcoming' do
    let!(:passed_event) { create(:open_day, starts_at: 1.day.ago) }
    let!(:upcoming_event) { create(:open_day, starts_at: 1.day.from_now) }
    let!(:current_event) { create(:open_day, starts_at: Date.today.end_of_day - 5.hours) }

    it 'only retrieves upcoming events' do
      expect(OpenDay.upcoming.pluck(:id)).to include(current_event.id)
      expect(OpenDay.upcoming.pluck(:id)).to include(upcoming_event.id)
      expect(OpenDay.upcoming.pluck(:id)).not_to include(passed_event.id)
    end

    it 'orders by starts_at, ascending' do
      expect(OpenDay.upcoming.first).to eq current_event
      expect(OpenDay.upcoming.last).to eq upcoming_event
    end
  end
end
