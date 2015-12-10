class CreateAdminScholarships < ActiveRecord::Migration
  def change
    create_table :admin_scholarships do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.integer :gender
      t.date :birth_date
      t.integer :employment_status
      t.text :reason
      t.text :future_plans
      t.integer :full_program
      t.integer :traineeship
      t.references :bootcamp, index: true
      t.string :status, default: "new"

      t.timestamps
    end
  end
end
