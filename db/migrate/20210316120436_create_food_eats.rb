class CreateFoodEats < ActiveRecord::Migration[6.1]
  def change
    create_table :food_eats do |t|
      t.references :user, null: false, foreign_key: true
      t.string :product_name, null: false
      t.string :food_code
      t.string :par, null: false
      t.float :calorie, null: false
      t.float :protein, null: false
      t.float :lipid, null: false
      t.float :carbohydrate, null: false
      t.float :percent, null: false
      t.date :date, null:false
      t.timestamps
    end
  end
  #
  # add_index :food_eats, [:updated_at, :created_at]
end
