class AddRegistrationToStudents < ActiveRecord::Migration
  def change
    add_column :students, :registration, :integer
  end
end
