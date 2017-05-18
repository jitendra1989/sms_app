class CreateMgInventoryStoreManagements < ActiveRecord::Migration
  def change
    create_table :mg_inventory_store_managements do |t|
      t.string :store_name
      t.text :description
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
