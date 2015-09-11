class RemoveSomeDiscountCodes < ActiveRecord::Migration
  def change
    Student.where('order_id is null').each do |student|
      student.discount_codes.destroy_all
    end
  end
end
