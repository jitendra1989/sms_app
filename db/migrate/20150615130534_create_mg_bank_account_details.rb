class CreateMgBankAccountDetails < ActiveRecord::Migration
  def change
    create_table :mg_bank_account_details do |t|
      t.integer :mg_employee_id
      t.string :bank_name
      t.text :branch_address
      t.string :account_number
      t.string :ifs_code
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
