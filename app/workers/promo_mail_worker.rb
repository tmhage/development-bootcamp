class PromoMailWorker < MailWorker

  sidekiq_options queue: :high

  def perform(order_id)
    @template_name = 'Personal Discount Codes'
    @template_slug = 'personal-discount-codes'

    @order = Order.includes(students: :discount_codes).find(order_id)
    return unless @order.paid?
    send_promo!
  end

  def send_promo!
    @order.students.each do |student|
      next if student.current_discount_code.blank?

      message = {
       auto_text: true,
       merge: true,
       merge_language: 'handlebars',
       subject: "Invite your friends and get discount on your next bootcamp!",
       from_name: "Development Bootcamp",
       from_email: "support@developmentbootcamp.nl",
       html: template['html'],
       merge_vars: [{
        'rcpt' => student.email,
        'vars' => [
           { name: 'name', content: student.first_name, },
           { name: 'promo', content: student.current_discount_code.code, }
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
