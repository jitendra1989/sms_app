class CreateMgFinanceTransactionDetails < ActiveRecord::Migration
  def change
    create_table :mg_finance_transaction_details do |t|
      t.integer :mg_transaction_id
      t.integer :mg_collection_id
      t.integer :mg_student_id
      t.integer :mg_fee_particular_id
      t.integer :mg_fee_fine_particular_id
      t.float :paid_amount
      t.boolean :is_partial_payment

      t.timestamps
    end
  end
end
