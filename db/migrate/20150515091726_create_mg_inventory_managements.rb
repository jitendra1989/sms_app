class CreateMgInventoryManagements < ActiveRecord::Migration
  def change
    create_table :mg_inventory_managements do |t|
      t.integer :mg_lab_id
      t.integer :mg_category_id
      t.string :item_name
      t.text :item_description
      t.decimal :quantity
      t.integer :mg_unit_id
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
