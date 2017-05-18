class CreateMgSportsItemManagements < ActiveRecord::Migration
  def change
    create_table :mg_sports_item_managements do |t|
      t.integer :mg_inventory_item_category_id
      t.integer :mg_inventory_item_id
      t.string :item_prefix
      t.string :label_text
      t.integer :mg_inventory_room_id
      t.integer :mg_inventory_rack_id
      t.integer :quantity
      t.integer :quantity_available
      t.date :date_of_expiry
      t.text :remark
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by
      t.integer :mg_school_id

      t.timestamps
    end
  end
end
