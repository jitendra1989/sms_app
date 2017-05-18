class CreateMgLabInventories < ActiveRecord::Migration
  def change
    create_table :mg_lab_inventories do |t|
      t.integer :mg_lab_id
      t.string :category_name
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
