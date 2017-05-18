class CreateMgAccounts < ActiveRecord::Migration
  def change
    create_table :mg_accounts do |t|
      t.string :mg_account_name
      t.integer :mg_department_id
      t.integer :mg_employee_id
      t.text :description

      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by
      t.timestamps
    end
  end
end
