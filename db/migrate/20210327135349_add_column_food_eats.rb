class AddColumnFoodEats < ActiveRecord::Migration[6.1]
  def change
    add_column :food_eats, :post_id, :integer
  end
end
