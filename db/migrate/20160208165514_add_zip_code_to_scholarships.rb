class AddZipCodeToScholarships < ActiveRecord::Migration
  def change
    add_column :scholarships, :zip_code, :string
  end
end
