class CreateMgPayslipLeaveDetails < ActiveRecord::Migration
  def change
    create_table :mg_payslip_leave_details do |t|
      t.integer :mg_employee_payslip_detail_id
      t.integer :mg_employee_leave_type_id
      t.float :leave_taken
      t.float :available_leave
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
