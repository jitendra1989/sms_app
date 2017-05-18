class CreateMgItemConsumptions < ActiveRecord::Migration
  def change
    create_table :mg_item_consumptions do |t|
      t.integer :mg_lab_id
      t.integer :mg_category_id
      t.integer :mg_item_id
      t.decimal :quantity_consumption
      t.date :date
      t.string :consumption_type
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
