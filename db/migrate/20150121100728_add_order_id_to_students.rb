class AddOrderIdToStudents < ActiveRecord::Migration
  def change
    add_reference :students, :order, index: true
  end
end
