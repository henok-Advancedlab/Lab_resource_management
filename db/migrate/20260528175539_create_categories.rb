class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      t.string :name, null: false

      t.timestamps
    end
    
    # Add unique index on name
    add_index :categories, :name, unique: true
  end
end
