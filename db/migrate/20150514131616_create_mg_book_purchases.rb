class CreateMgBookPurchases < ActiveRecord::Migration
  def change
    create_table :mg_book_purchases do |t|
      t.string :vendor_name
      t.date :date_of_purchase
      t.float :Amount_paid
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
