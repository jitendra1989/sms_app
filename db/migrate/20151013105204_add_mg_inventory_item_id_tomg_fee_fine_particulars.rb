class AddMgInventoryItemIdTomgFeeFineParticulars < ActiveRecord::Migration
  def change
  	add_column :mg_fee_fine_particulars,:mg_inventory_item_id,:integer
  end
end
