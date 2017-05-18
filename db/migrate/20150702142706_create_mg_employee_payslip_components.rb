class CreateMgEmployeePayslipComponents < ActiveRecord::Migration
  def change
    create_table :mg_employee_payslip_components do |t|
      t.integer :mg_employee_payslip_detail_id
      t.integer :mg_salary_component_id
      t.integer :mg_school_id
      t.float :amount
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
