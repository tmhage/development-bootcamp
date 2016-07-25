class PreworkMailWorker < MailWorker

  sidekiq_options queue: :high

  def perform(order_id)
    @template_name = 'Prep Mail Beginner Bootcamp'
    @template_slug = 'prep-mail-beginner-bootcamp'

    @order = Order.find(order_id)
    send_mail!
  end

  def send_mail!
    @order.students.each do |student|
      message = {
       auto_text: true,
       merge: true,
       merge_language: 'handlebars',
       subject: "#{student.first_name}, prep for your Beginner Bootcamp!",
       from_name: "Codaisseur",
       from_email: "support@codaisseur.com",
       html: template['html'],
       merge_vars: [{
        'rcpt' => student.email,
        'vars' => [
           { name: 'first_name', content: student.first_name, },
           { name: 'last_name', content: student.last_name, },
           { name: 'level', content: @order.bootcamp.level_name, },
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
