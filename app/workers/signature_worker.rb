require 'hello_sign'

class SignatureWorker
  include Sidekiq::Worker

  def perform(contract_id)
    contract = TraineeContract.find(contract_id)

    params = {
      test_mode: Rails.env.production? ? 1 : 0,
      template_id: ENV['HELLOSIGN_TEMPLATE_ID'] || '120c7e7ff690f52d90e6b4872e1871a859e129a4',
      signers: [
        {
          email_address: contract.scholarship.email,
          name: "#{contract.scholarship.first_name} #{contract.scholarship.last_name}",
          role: 'Trainee'
        }
      ],
      custom_fields: {
        #salutation: contract.scholarship.gender == 'male' ? 'De heer' : 'Mevrouw',
        startDate: "31/1/2016",
        birthDate: "#{contract.scholarship.birth_date.day}/#{contract.scholarship.birth_date.month}/#{contract.scholarship.birth_date.year}",
        fullName: "#{contract.scholarship.first_name} #{contract.scholarship.last_name}",
      },
      title: 'Traineeship Contract Codaisseur Academy',
      subject: "#{contract.scholarship.first_name}, please sign your traineeship contract",
      message: <<EMAIL
Hi,

Please sign this training contract to participate in Codaisseur's Traineeship Program.

You will be asked to attach a photo copy of your ID to go along with your signature.

Cheers,

Wouter de Vos
Codaisseur
EMAIL
    }

    puts params

    client.send_signature_request_with_template(params)
  end

  def client
    @client ||= HelloSign::Client.new(
      api_key: ENV['HELLOSIGN_API_KEY'] || "d3f2071d5836fbc20f642d86b28cf3ecf7e472a76a4e4fe27343c53beca9c587")
  end
end
