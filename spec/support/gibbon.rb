RSpec.configure do |config|
  config.before do
    allow_any_instance_of(Gibbon::Request).to receive_message_chain(:lists, :members, :create) do |args|
      args
    end
  end
end
