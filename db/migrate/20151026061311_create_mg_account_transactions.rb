class CreateMgAccountTransactions < ActiveRecord::Migration
  def change
    create_table :mg_account_transactions do |t|
      t.integer :mg_to_account_id
      t.integer :mg_from_account_id
      t.date :current_date
      t.string :from_module
      t.integer :mg_particular_id
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
