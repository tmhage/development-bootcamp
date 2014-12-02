class CreateSpeakers < ActiveRecord::Migration
  def change
    create_table :speakers do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :twitter_handle
      t.string :website

      t.text   :remarks
      t.text   :description

      t.datetime :activated_at

      t.timestamps
    end
  end
end
