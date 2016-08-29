class AddSoldOutToBootcamps < ActiveRecord::Migration
  def change
    add_column :bootcamps, :sold_out, :boolean, default: false
  end
end
