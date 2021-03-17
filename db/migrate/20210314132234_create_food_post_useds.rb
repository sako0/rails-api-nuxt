class CreateFoodPostUseds < ActiveRecord::Migration[6.1]
  def change
    create_table :food_post_useds do |t|
      t.references :user, foreign_key: true, null: false
      t.string :food_code, null: false
      t.references :food_post, foreign_key: true, null: false
      t.references :target_user, foreign_key: { to_table: :users }, null: false

      t.timestamps
    end
  end
end
