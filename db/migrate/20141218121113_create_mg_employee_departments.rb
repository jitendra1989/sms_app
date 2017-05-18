class CreateMgEmployeeDepartments < ActiveRecord::Migration
  def change
    create_table :mg_employee_departments do |t|
      t.string :department_name
      t.string :department_code
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
