class AddAllergiesToStudents < ActiveRecord::Migration
  def change
    add_column :students, :allergies, :text
  end
end
