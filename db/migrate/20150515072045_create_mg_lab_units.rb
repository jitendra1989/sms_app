class CreateMgLabUnits < ActiveRecord::Migration
  def change
    create_table :mg_lab_units do |t|
      t.string :unit_name
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
