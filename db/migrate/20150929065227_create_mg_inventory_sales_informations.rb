class CreateMgInventorySalesInformations < ActiveRecord::Migration
  def change
    create_table :mg_inventory_sales_informations do |t|
      t.integer :mg_inventory_item_category_id
      t.date :date_of_sales
      t.float :amount
      t.integer :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
