require 'rspec/core/shared_context'

module FactoryModels
  extend RSpec::Core::SharedContext

  let(:user) { FactoryGirl.create :user }
end

module LoggedInAsUser
  extend RSpec::Core::SharedContext
  include Devise::TestHelpers
  include FactoryModels

  before do
    @request.env['HTTPS'] = 'on'
    sign_in user
  end
end
