class ScholarshipDecorator < Draper::Decorator
  delegate_all

  def full_name
    "#{object.first_name} #{object.last_name}"
  end

  def helpscout_url
    "https://secure.helpscout.net/mailbox/cc832e3adfe530e1/new-ticket/522398/?email=#{object.email}&name=#{full_name}&phone=#{object.phone}"
  end
end
