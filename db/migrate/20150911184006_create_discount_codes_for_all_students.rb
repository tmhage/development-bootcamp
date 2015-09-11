class CreateDiscountCodesForAllStudents < ActiveRecord::Migration
  def change
    Student.all.map(&:reset_discount_code!)
  end
end
