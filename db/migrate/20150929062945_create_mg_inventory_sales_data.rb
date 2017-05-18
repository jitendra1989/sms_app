class CreateMgInventorySalesData < ActiveRecord::Migration
  def change
    create_table :mg_inventory_sales_data do |t|
      t.integer :mg_inventory_item_category_id
      t.date :date_of_sales
      t.float :amount
      t.integer :mg_inventory_item_id
      t.float :cost_per_unit
      t.float :no_of_units
      t.float :total
      t.integer :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
