class AddPublishedAtToBootcamps < ActiveRecord::Migration
  def change
    add_column :bootcamps, :published_at, :date
    # Don't unpublish current bootcamps ;)
    Bootcamp.all.each { |b| b.update(published_at: Date.today) }
  end
end
