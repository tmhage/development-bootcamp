class AddOwnsLaptopToStudents < ActiveRecord::Migration
  def change
    add_column :students, :owns_laptop, :bool, default: false
  end
end
