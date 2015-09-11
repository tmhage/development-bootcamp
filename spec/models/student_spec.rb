require 'rails_helper'

RSpec.describe Student, :type => :model do
  it { should respond_to :first_name }
  it { should respond_to :last_name }
  it { should respond_to :twitter_handle }
  it { should respond_to :github_handle }
  it { should respond_to :gravatar_url }
  it { should respond_to :birth_date }
  it { should respond_to :email }
  it { should respond_to :remarks }

  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :phone_number }

  describe 'clean_twitter_handle' do
    let(:student) { build_stubbed(:student, twitter_handle: '@foo') }
    subject { student.twitter_handle }
    it { should eq '@foo' }

    context 'after_validation' do
      before { student.valid? }
      it { should eq 'foo' }
    end
  end

  describe 'ensure_discount_code' do
    let(:student) { create(:student) }
    it { expect(student.discount_codes.first).to be_present }
    it { expect(student.discount_codes.first).to be_valid }
  end

  describe 'reset_discount_code' do
    let(:student) { create(:student) }
    it { expect { student.reset_discount_code! }.to change { student.discount_codes.count }.from(1).to(2) }
    it { expect { student.reset_discount_code! }.not_to change { student.discount_codes.valid.count } }
    it { expect { student.reset_discount_code! }.to change { student.current_discount_code.id }.by(1) }
  end
end
