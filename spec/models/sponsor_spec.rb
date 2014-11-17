require 'rails_helper'

RSpec.describe Sponsor, type: :model do
  it { should respond_to :name }
  it { should respond_to :description }
  it { should respond_to :slug }
  it { should respond_to :website }
  it { should respond_to :logo }
  it { should respond_to :hiring }
  it { should respond_to :email }
  it { should respond_to :remarks }
  it { should respond_to :activated_at }

  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of(:name).scoped_to(:email) }
end