class CreateMgInventoryItemCategories < ActiveRecord::Migration
  def change
    create_table :mg_inventory_item_categories do |t|
      t.string :name
      t.text :description
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
