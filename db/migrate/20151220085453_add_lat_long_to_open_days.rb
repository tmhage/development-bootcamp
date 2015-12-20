class AddLatLongToOpenDays < ActiveRecord::Migration
  def change
    add_column :open_days, :latitude, :float
    add_column :open_days, :longitude, :float
  end
end
