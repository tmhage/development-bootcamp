class AddBioToSpeaker < ActiveRecord::Migration
  def change
    add_column :speakers, :bio, :text
  end
end
