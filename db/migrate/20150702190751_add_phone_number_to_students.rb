class AddPhoneNumberToStudents < ActiveRecord::Migration
  def change
    add_column :students, :phone_number, :text
  end
end
