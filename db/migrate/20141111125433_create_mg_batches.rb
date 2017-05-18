class CreateMgBatches < ActiveRecord::Migration
  def change
    create_table :mg_batches do |t|
    	t.string :name
      t.integer :mg_course_id
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :is_active
      t.integer :mg_employee_id
      
      # audit fields
      t.boolean :is_deleted
      # school id
      t.integer :mg_school_id
      
      # Audit Fields
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
