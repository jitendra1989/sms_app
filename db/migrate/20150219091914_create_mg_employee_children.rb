class CreateMgEmployeeChildren < ActiveRecord::Migration
  def change
    create_table :mg_employee_children do |t|
      t.integer :mg_user_id
      t.string :employee_name
      t.string :employee_type
      t.string :employee_id
      t.date :joining_date
     

      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
