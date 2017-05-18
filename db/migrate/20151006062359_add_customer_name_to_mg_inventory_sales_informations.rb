class AddCustomerNameToMgInventorySalesInformations < ActiveRecord::Migration
  def change
    add_column :mg_inventory_sales_informations, :customer_name, :string
  end
end
