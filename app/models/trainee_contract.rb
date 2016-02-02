class TraineeContract < ActiveRecord::Base
  belongs_to :scholarship

  def send_sign_request
    SignatureWorker.perform_async(id)
  end
end
