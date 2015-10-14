class CreateAdminUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.references :user, index: true
      t.string :role
      t.string :twitter_handle
      t.text :linkedin_url
      t.string :github_handle
      t.boolean :core, default: false
      t.boolean :teacher, default: false
      t.boolean :coach, default: true

      t.timestamps
    end
  end
end
