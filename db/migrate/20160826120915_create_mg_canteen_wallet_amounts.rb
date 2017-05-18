class CreateMgCanteenWalletAmounts < ActiveRecord::Migration
  def change
    create_table :mg_canteen_wallet_amounts do |t|
      t.string :user_type
      t.integer :mg_student_id
      t.integer :mg_batch_id
      t.integer :mg_employee_id
      t.integer :mg_employee_department_id
      t.integer :wallet_amount

      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by
      t.boolean :is_deleted
      t.timestamps
    end
  end
end
