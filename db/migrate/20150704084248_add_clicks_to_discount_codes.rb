class AddClicksToDiscountCodes < ActiveRecord::Migration
  def change
    add_column :discount_codes, :clicks, :integer
  end
end
