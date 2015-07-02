class FillInStudentPhoneNumberFromOrder < ActiveRecord::Migration
  def change
    Student.joins(:order).each do |student|
      next unless student.order.present?
      student.update(phone_number: student.order.billing_phone)
    end
  end
end
