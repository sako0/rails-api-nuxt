class CreateFoodPosts < ActiveRecord::Migration[6.1]
  def change
    create_table :food_posts do |t|
      t.string :food_code, null: false
      t.references :user, foreign_key: true
      t.string :product_name, null: false
      t.string :par, null: false
      t.float :calorie, null: false
      t.float :protein, null: false
      t.float :lipid, null: false
      t.float :carbohydrate, null: false

      t.timestamps
    end
    add_index :food_posts, [:user_id, :created_at]
  end
end
