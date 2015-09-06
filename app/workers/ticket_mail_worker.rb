class TicketMailWorker < MailWorker

  sidekiq_options queue: :high

  def perform(order_id)
    @template_name = 'Student Ticket'
    @template_slug = 'student-ticket'

    @order = Order.find(order_id)
    return unless @order.paid?
    send_tickets!
  end

  def send_tickets!
    @order.students.each do |student|
      message = {
       auto_text: true,
       merge: true,
       merge_language: 'handlebars',
       subject: "Your Development Bootcamp Ticket",
       from_name: "Development Bootcamp",
       from_email: "support@developmentbootcamp.nl",
       html: template['html'],
       merge_vars: [{
        'rcpt' => student.email,
        'vars' => [
           { name: 'first_name', content: student.first_name, },
           { name: 'last_name', content: student.last_name, },
           { name: 'level', content: @order.bootcamp.level_name, },
           { name: 'dietary_wishes', content: student.allergies || 'none', },
           { name: 'student_identifier', content: student.identifier, },
           { name: 'start_date', content: @order.bootcamp.starts_at.strftime("%B %e"), }
        ]
       }],
       to: [
         {
           email: student.email,
           name: "#{student.first_name} #{student.last_name}"
         }
       ],
      }
      Rails.logger.info mandrill.messages.send(message)
    end
  end
end
