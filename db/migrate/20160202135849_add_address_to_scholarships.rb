class AddAddressToScholarships < ActiveRecord::Migration
  def change
    add_column :scholarships, :address, :text
    add_column :scholarships, :city, :string
  end
end
