class AddStudentToDiscountCodes < ActiveRecord::Migration
  def change
    add_reference :discount_codes, :student, index: true
  end
end
