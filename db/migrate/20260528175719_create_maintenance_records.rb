class CreateMaintenanceRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :maintenance_records do |t|
      t.references :equipment, null: false, foreign_key: true
      t.datetime :performed_at, null: false
      t.text :description, null: false

      t.timestamps
    end

    # Add composite index on equipment_id and performed_at
    add_index :maintenance_records, [ :equipment_id, :performed_at ]
  end
end
