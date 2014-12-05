class AddPlanToSponsors < ActiveRecord::Migration
  def change
    add_column :sponsors, :plan, :string
  end
end
