class AddLinkedInProfileUrlToScholarships < ActiveRecord::Migration
  def change
    add_column :scholarships, :linked_in_profile_url, :text
  end
end
