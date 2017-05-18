class AddAccountIdToMgInventorySalesInformation < ActiveRecord::Migration
  def change
  	add_column :mg_inventory_sales_informations, :mg_account_id, :integer
  end
end
