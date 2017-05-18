class CreateMgUnits < ActiveRecord::Migration
  def change
    create_table :mg_units do |t|
      t.integer :mg_syllabus_id
      t.string :unit_name
      t.text :description
      t.integer :hour
      t.integer :min
      t.integer :time

      
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by
      t.boolean :is_deleted

      t.timestamps
    end
  end
end
