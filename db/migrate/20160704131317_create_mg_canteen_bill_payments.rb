class CreateMgCanteenBillPayments < ActiveRecord::Migration
  def change
    create_table :mg_canteen_bill_payments do |t|

      t.integer :mg_canteen_bill_detail_id
      t.integer :mg_food_item_id
      t.integer :quantity
      t.integer :amount

      t.integer :is_deleted
      t.integer :created_by
      t.integer :updated_by
      t.integer :mg_school_id
      t.timestamps
    end
  end
end
