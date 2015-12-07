class AddDutchTitleToPages < ActiveRecord::Migration
  def change
    add_column :pages, :dutch_title, :string
  end
end
