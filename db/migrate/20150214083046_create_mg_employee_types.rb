class CreateMgEmployeeTypes < ActiveRecord::Migration
  def change
    create_table :mg_employee_types do |t|
      t.string :employee_type

      
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
