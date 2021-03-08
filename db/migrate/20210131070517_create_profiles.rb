class CreateProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :age
      t.string :sex
      t.string :trend
      t.string :notes
      t.string :url

      t.timestamps
    end
    add_index :profiles, [:created_at, :updated_at]
  end
end
