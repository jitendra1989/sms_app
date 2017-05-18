class CreateMgSportsPayDeductions < ActiveRecord::Migration
  def change
    create_table :mg_sports_pay_deductions do |t|
      t.date :mm_yyyy
      t.integer :mg_employee_category_id
      t.integer :mg_employee_department_id
      t.integer :mg_employee_id
      t.integer :amount
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by
      t.integer :mg_school_id

      t.timestamps
    end
  end
end
