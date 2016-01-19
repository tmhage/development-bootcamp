class TraineeshipMailWorker < MailWorker

  sidekiq_options queue: :medium_high

  def perform(scholarship_id)
    @template_name = 'Traineeship Application Received'
    @template_slug = 'traineeship-application-received'

    @scholarship = Scholarship.find(scholarship_id)
    send_thank_you_mail!
  end

  def send_thank_you_mail!
    message = {
      auto_text: true,
      merge: true,
      merge_language: 'handlebars',
      subject: "#{@scholarship.first_name}, thank you for your application!",
      from_name: "Codaisseur Traineeship",
      from_email: "support@developmentbootcamp.nl",
      html: template['html'],
      merge_vars: [{
       'rcpt' => @scholarship.email,
       'vars' => [{ name: 'name', content: @scholarship.first_name }]
      }],
      to: [
        {
          email: @scholarship.email,
          name: "#{@scholarship.first_name} #{@scholarship.last_name}"
        }
      ],
    }
    Rails.logger.info mandrill.messages.send(message)
  end
end
