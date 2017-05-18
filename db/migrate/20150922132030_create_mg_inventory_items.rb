class CreateMgInventoryItems < ActiveRecord::Migration
  def change
    create_table :mg_inventory_items do |t|
      t.string :name
      t.string :code
      t.integer :mg_category_id
      t.string :item_type
      t.string :prefix
      t.text :description
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
