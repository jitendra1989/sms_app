class CreateMgEmployeePayslipDetails < ActiveRecord::Migration
  def change
    create_table :mg_employee_payslip_details do |t|
      t.integer :mg_employee_id
      t.float :extra_leave_taken
      t.integer :month
      t.integer :year
      t.string  :is_approved
      t.float   :no_of_payable_days_in_the_month
      t.float   :leaves_taken_till_date_in_the_year
      t.float   :leave_balance
      t.float   :total_leave
      t.float   :total_Gross_salary
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
 # add_column :mg_employee_payslip_details, :, :float
 #     add_column :mg_employee_payslip_details, :, :float
 #     add_column :mg_employee_payslip_details, :, :float
 #     add_column :mg_employee_payslip_details, :, :float
 #     add_column :mg_employee_payslip_details, :, :floa