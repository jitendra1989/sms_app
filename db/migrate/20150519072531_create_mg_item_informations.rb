class CreateMgItemInformations < ActiveRecord::Migration
  def change
    create_table :mg_item_informations do |t|
      t.integer :mg_purchase_id
      t.integer :mg_category_id
      t.string :item_name
      t.decimal :cost
      t.decimal :unit
      t.decimal :total
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
