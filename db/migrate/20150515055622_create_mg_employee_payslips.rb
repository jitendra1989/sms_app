class CreateMgEmployeePayslips < ActiveRecord::Migration
  def change
    create_table :mg_employee_payslips do |t|
      t.integer :mg_employee_id
      t.decimal :payscale, :precision => 8, :scale => 2
      t.date :from_date
      t.date :to_date
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
