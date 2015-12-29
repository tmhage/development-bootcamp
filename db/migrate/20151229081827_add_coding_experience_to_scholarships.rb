class AddCodingExperienceToScholarships < ActiveRecord::Migration
  def change
    add_column :scholarships, :coding_experience, :text, array: true, default: []
  end
end
