class CreateMgCanteenBillDetails < ActiveRecord::Migration
  def change
    create_table :mg_canteen_bill_details do |t|
      t.string :user_type
      t.integer :mg_student_id
      t.string :student_admission_no
      t.integer :mg_batch_id
      t.integer :mg_employee_id
      t.string :employee_no
      t.integer :mg_employee_department_id
      t.integer :total_amount
      t.integer :paid_amount
      t.integer :balance_amount
      t.integer :mg_user_id
      
      t.integer :is_deleted
      t.integer :created_by
      t.integer :updated_by
      t.integer :mg_school_id
      t.timestamps
    end
  end
end

