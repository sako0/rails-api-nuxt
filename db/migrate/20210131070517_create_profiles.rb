class CreateProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :age, null: false
      t.boolean :sex, null: false
      t.integer :height, null: false
      t.integer :weight
      t.integer :target_weight, null: false
      t.float :action_level, null: false
      t.string :notes

      t.timestamps
    end
    add_index :profiles, [:created_at, :updated_at]
  end
end
