class CreateMgFinanceFees < ActiveRecord::Migration
  def change
    create_table :mg_finance_fees do |t|
      t.integer :mg_fee_collection_id
      t.string :transaction_id
      t.integer :student_id
      t.boolean :is_paid

      #Audit fields
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
