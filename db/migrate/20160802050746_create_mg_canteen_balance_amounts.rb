class CreateMgCanteenBalanceAmounts < ActiveRecord::Migration
  def change
    create_table :mg_canteen_balance_amounts do |t|
      t.integer :mg_canteen_bill_detail_id
      t.integer :paid_amount
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by
      t.timestamps
    end
  end
end
