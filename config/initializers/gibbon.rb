Gibbon::Request.api_key = ENV['DB_MAILCHIMP_API_KEY'] || ''
Gibbon::Request.timeout = 15
Gibbon::Request.throws_exceptions = false

module MailingLists
  STUDENTS = 'aff9cced90'
  SPEAKERS = '37a3a54ac4'
  SPONSORS = '6ce7b074db'
  PARTICIPANTS = 'b9f9d652bd'
end
