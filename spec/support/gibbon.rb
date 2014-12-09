RSpec.configure do |config|
  config.before do
    allow_any_instance_of(Gibbon::API).to receive_message_chain(:lists, :subscribe) do |args|
      args
    end
  end
end
