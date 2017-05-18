class AddIsToCentralToMgFeePaMgInventorySalesInformation < ActiveRecord::Migration
  def change
  	add_column :mg_inventory_sales_informations, :is_to_central, :boolean
  end
end
