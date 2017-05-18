class CreateMgFinanceTransactions < ActiveRecord::Migration
  def change
    create_table :mg_finance_transactions do |t|
      t.string :title
      t.string :description
      t.string :amount
      t.boolean :fine_included
      t.integer :category_id
      t.integer :mg_student_id
      t.integer :finance_fee_id
      t.date :transaction_date
      t.string :fine_amount
      t.integer :master_transaction_id
      t.integer :finance_id
      t.string :finance_type
      t.integer :payee_id
      t.string :payee_type
      t.string :receipt_no
      t.string :voucher_no

      #Audit fields
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
