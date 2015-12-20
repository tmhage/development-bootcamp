class CreateAdminOpenDays < ActiveRecord::Migration
  def change
    create_table :open_days do |t|
      t.datetime :starts_at
      t.text :address
      t.text :description_en
      t.text :description_nl
      t.string :facebook_event_url

      t.timestamps
    end
  end
end
