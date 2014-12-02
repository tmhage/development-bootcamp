require 'rails_helper'

RSpec.describe Speaker, type: :model do
  it { should respond_to :first_name }
  it { should respond_to :last_name }
  it { should respond_to :description }
  it { should respond_to :twitter_handle }
  it { should respond_to :gravatar_url }
  it { should respond_to :website }
  it { should respond_to :email }
  it { should respond_to :remarks }
  it { should respond_to :activated_at }

  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of(:email) }

  describe 'clean_twitter_handle' do
    let(:speaker) { build_stubbed(:speaker, twitter_handle: '@foo') }
    subject { speaker.twitter_handle }
    it { should eq '@foo' }

    context 'after_validation' do
      before { speaker.valid? }
      it { should eq 'foo' }
    end
  end
end
