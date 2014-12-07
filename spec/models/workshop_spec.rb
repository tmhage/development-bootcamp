require 'rails_helper'

RSpec.describe Admin::Workshop, :type => :model do
  it { should respond_to :title }
  it { should respond_to :description }
  it { should respond_to :prerequisite }
  it { should respond_to :outcome }
  it { should respond_to :published }
  it { should respond_to :starts_at }

  it { should validate_presence_of :title }
  it { should validate_presence_of :description }
end
