class StudentsController < ApplicationController
  before_filter :load_student

  def qr_code
    @qr_code = RQRCode::QRCode.new("https://www.delevopmentbootcamp.nl/students/#{@student.identifier}/check", size: 12, level: :h)
    qr_code_img = @qr_code.to_img
    respond_to do |format|
      format.png do
        response.headers['Cache-Control'] = "public, max-age=#{12.hours.to_i}"
        response.headers['Content-Type'] = 'image/png'
        response.headers['Content-Disposition'] = 'inline'
        render text: qr_code_img.resize(250, 250)
      end
    end
  end

  def check_qr_code
    order = @student.order
    status =  'paid' if @student.order.paid?
    status = @student.order.payment.status if status.nil?
    render json: { status: status, student: @student }
  end

  def load_student
    @student = Student.find_by_identifier(params[:id])
  end
end
