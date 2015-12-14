class CreateAdminScholarships < ActiveRecord::Migration
  def change
    create_table :scholarships do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :gender
      t.date :birth_date
      t.string :education_level
      t.string :employment_status
      t.text :reason
      t.text :future_plans
      t.boolean :full_program
      t.boolean :traineeship
      t.string :status, default: "new"

      t.references :bootcamp, index: true

      t.timestamps
    end
  end
end
