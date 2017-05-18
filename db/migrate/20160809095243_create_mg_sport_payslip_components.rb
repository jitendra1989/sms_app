class CreateMgSportPayslipComponents < ActiveRecord::Migration
  def change
    create_table :mg_sport_payslip_components do |t|
      
      t.integer :mg_employee_payslip_detail_id
      t.integer :mg_sports_pay_deduction_id
      t.integer :amount
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by
      t.boolean :is_deleted
      t.timestamps
    end
  end
end
