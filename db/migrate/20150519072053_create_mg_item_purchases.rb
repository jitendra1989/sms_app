class CreateMgItemPurchases < ActiveRecord::Migration
  def change
    create_table :mg_item_purchases do |t|
      t.integer :mg_lab_id
      t.string :vendor_name
      t.date :date
      t.decimal :amount_paid
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
