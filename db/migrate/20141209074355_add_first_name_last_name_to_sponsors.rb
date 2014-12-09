class AddFirstNameLastNameToSponsors < ActiveRecord::Migration
  def change
    add_column :sponsors, :first_name, :string
    add_column :sponsors, :last_name, :string
  end
end
