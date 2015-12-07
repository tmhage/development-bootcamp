class AddDutchToPages < ActiveRecord::Migration
  def change
    add_column :pages, :dutch_version, :text
  end
end
