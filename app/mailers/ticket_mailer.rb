require 'mandrill'

module TicketMailer
  extend ActiveSupport::Concern

  included do
    def send_tickets!
      return unless @order.paid?

      mandril = Mandrill::API.new

      @order.students.each do |student|
        @student = student
        html = render_to_string('ticket_mailer/ticket', layout: false)
        message = {
         subject: "Your Development Bootcamp Ticket",
         from_name: "Development Bootcamp",
         from_email: "support@developmentbootcamp.nl",
         html: html,
         to: [
           {
             email: student.email,
             name: "#{student.first_name} #{student.last_name}"
           }
         ],
        }
        Rails.logger.info mandril.messages.send(message)
      end
    end
  end
end
