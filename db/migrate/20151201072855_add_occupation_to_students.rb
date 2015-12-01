class AddOccupationToStudents < ActiveRecord::Migration
  def change
    add_column :students, :occupation, :string
  end
end
