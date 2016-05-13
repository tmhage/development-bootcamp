class MoneybirdWorker
  include Sidekiq::Worker

  # Usage:
  #
  # MoneybirdWorker.perform_async(:create_contact, :scholarship, scholarship.id)
  #
  def perform(action, klass, id)
    object = klass.to_s.camelize.constantize.send(:find, id)
    self.send(action, object)
  end

  def create_contact(object)
    Moneybird::Contact.create(object)
  end
end
