require 'rails_helper'

RSpec.describe Lesson, type: :model do
  it { should respond_to :title }
  it { should respond_to :description }
  it { should respond_to :published }
  it { should respond_to :starts_at }
  it { should respond_to :duration }
  it { should respond_to :image }
  it { should respond_to :icon }

  it { should validate_presence_of :title }
  it { should validate_presence_of :description }

  it { should belong_to :workshop }
end
