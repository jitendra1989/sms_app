class CreateMgInventoryRoomManagements < ActiveRecord::Migration
  def change
    create_table :mg_inventory_room_managements do |t|
      t.string :room_no
      t.integer :mg_inventory_store_management_id
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
