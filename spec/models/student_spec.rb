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
  it { should respond_to :preferred_level }

  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :email }

  describe 'clean_twitter_handle' do
    let(:student) { build_stubbed(:student, twitter_handle: '@foo') }
    subject { student.twitter_handle }
    it { should eq '@foo' }

    context 'after_validation' do
      before { student.valid? }
      it { should eq 'foo' }
    end
  end
end
