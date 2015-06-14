require 'mandrill'

class MailWorker
  include Sidekiq::Worker

  def template
    mandrill.templates.render @template_name, [{:name => @template_slug}]
  end

  def perform(*params)
    raise 'not implemented'
  end

  def mandrill
    @mandrill ||= Mandrill::API.new
  end
end
