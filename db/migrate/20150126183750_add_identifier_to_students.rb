class AddIdentifierToStudents < ActiveRecord::Migration
  def change
    add_column :students, :identifier, :uuid
    add_index :students, :identifier

    Student.all.each { |s| s.create_identifier; s.save }
  end
end
