class CreateMgInventoryItemManagements < ActiveRecord::Migration
  def change
    create_table :mg_inventory_item_managements do |t|
      t.integer :mg_inventory_item_category_id
      t.string :mg_inventory_item_id
      t.string :integer
      t.string :item_prefix
      t.string :label_text
      t.string :item_type
      t.integer :mg_inventory_room_id
      t.integer :mg_inventory_rack_id
      t.integer :quantity
      t.integer :minimum_quantity
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
