class CreateMgAccountCentralIncharges < ActiveRecord::Migration
  def change
    create_table :mg_account_central_incharges do |t|
      t.integer :mg_employee_department_id
      t.integer :mg_employee_id
      t.integer :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by
      t.string :status

      t.timestamps
    end
  end
end
