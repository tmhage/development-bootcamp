require 'mandrill'

class MailWorker
  include Sidekiq::Worker

  self.template_name = 'Not Implemented'
  self.template_slug = 'not-implemented'

  def template
    mandrill.templates.render self.class.template_name, [{:name => self.class.template_slug}]
  end

  def perform(*params)
    raise 'not implemented'
  end

  def mandrill
    @mandrill ||= Mandrill::API.new
  end
end
