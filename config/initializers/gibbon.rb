Gibbon::API.api_key = ENV['DB_MAILCHIMP_API_KEY'] || ''
Gibbon::API.timeout = 15
Gibbon::API.throws_exceptions = false

module MailingLists
  STUDENTS = 'aff9cced90'
  SPEAKERS = '37a3a54ac4'
  SPONSORS = '6ce7b074db'
end
