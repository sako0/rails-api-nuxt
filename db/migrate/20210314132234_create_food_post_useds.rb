class CreateFoodPostUseds < ActiveRecord::Migration[6.1]
  def change
    create_table :food_post_useds do |t|
      t.integer :user_id
      t.string :food_code
      t.string :food_post_id
      t.integer :target_user_id

      t.timestamps
    end
  end
end
