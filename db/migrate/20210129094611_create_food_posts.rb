class CreateFoodPosts < ActiveRecord::Migration[6.1]
  def change
    create_table :food_posts do |t|
      t.string :food_code
      t.references :user, foreign_key: true
      t.string :product_name
      t.string :par
      t.float :calorie
      t.float :protein
      t.float :lipid
      t.float :carbohydrate

      t.timestamps
    end
    add_index :food_posts, [:user_id, :created_at]
  end
end
