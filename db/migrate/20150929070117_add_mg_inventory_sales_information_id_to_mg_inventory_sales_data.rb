class AddMgInventorySalesInformationIdToMgInventorySalesData < ActiveRecord::Migration
  def change
    add_column :mg_inventory_sales_data, :mg_inventory_sales_information_id, :integer
  end
end
