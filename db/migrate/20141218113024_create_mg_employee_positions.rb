class CreateMgEmployeePositions < ActiveRecord::Migration
  def change
    create_table :mg_employee_positions do |t|
      t.integer :mg_employee_category_id
      t.string :position_name
      t.boolean :status
      

      #Audit fields
        t.boolean :is_deleted
        t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by
      t.timestamps
    end
  end
end
