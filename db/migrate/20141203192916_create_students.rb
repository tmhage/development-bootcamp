class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :twitter_handle
      t.date :birth_date
      t.string :preferred_level
      t.string :github_handle
      t.text :remarks

      t.timestamps
    end
  end
end
