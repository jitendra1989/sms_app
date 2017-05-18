class CreateMgCanteenAmountTransactions < ActiveRecord::Migration
  def change
    create_table :mg_canteen_amount_transactions do |t|
      t.boolean :is_central
      t.boolean :is_account
      t.integer :amount
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
