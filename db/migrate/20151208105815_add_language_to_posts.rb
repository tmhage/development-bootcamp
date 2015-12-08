class AddLanguageToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :language, :string, default: "en"
  end
end
