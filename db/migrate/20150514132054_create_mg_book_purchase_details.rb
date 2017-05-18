class CreateMgBookPurchaseDetails < ActiveRecord::Migration
  def change
    create_table :mg_book_purchase_details do |t|
      t.string :book_name
      t.string :author
      t.string :publisher
      t.float :cost
      t.integer :no_of_copies
      t.float :total
      t.integer :mg_course_id
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by
      t.integer :mg_book_purchase_id
      t.timestamps
    end
  end
end
