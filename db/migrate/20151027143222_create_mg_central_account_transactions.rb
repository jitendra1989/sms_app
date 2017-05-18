class CreateMgCentralAccountTransactions < ActiveRecord::Migration
  def change
    create_table :mg_central_account_transactions do |t|
      t.integer :mg_to_account_id
      t.integer :mg_from_account_id
      t.date :current_date
      t.string :for_module
      t.integer :mg_particular_id
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by
      t.integer :amount
      t.string :transaction_type
      t.string :amount_transfer_type

      t.timestamps
    end
  end
end
