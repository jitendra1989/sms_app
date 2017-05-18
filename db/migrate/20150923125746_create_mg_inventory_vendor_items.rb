class CreateMgInventoryVendorItems < ActiveRecord::Migration
  def change
    create_table :mg_inventory_vendor_items do |t|
      t.integer :mg_vendor_id
      t.integer :mg_item_id
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
