class CreateMgInventoryItemConsumptions < ActiveRecord::Migration
  def change
    create_table :mg_inventory_item_consumptions do |t|
      t.integer :mg_inventory_item_category_id
      t.integer :mg_inventory_item_id
      t.string :item_prefix
      t.string :item_type
      t.integer :mg_inventory_room_id
      t.integer :mg_inventory_rack_id
      t.integer :quantity_available
      t.integer :quantity_consumed
      t.integer :mg_school_id
      t.date :consumption_date
      t.string :consumption_type
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
