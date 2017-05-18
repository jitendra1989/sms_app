class AddColumnUnitQuantityToMgCanteenBillPayment < ActiveRecord::Migration
  def change
    add_column :mg_canteen_bill_payments, :unit_quantity, :integer
  end
end
