class CreateMgBooksInventories < ActiveRecord::Migration
  def change
    create_table :mg_books_inventories do |t|
      t.integer :book_no
      t.string :book_name
      t.string :author
      t.string :publisher
      t.string :edition
      t.float :cost
      t.integer :mg_books_category_id
      t.integer :mg_course_id
      t.boolean :non_issuable
      t.boolean :is_damaged
      t.boolean :is_lost
      t.string :status
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by
      t.string  :issued_to
      t.date   :due_date
      t.integer :reserved_by
      t.date :reservation_due_date
      t.integer :mg_books_transaction_id
      t.date :issued_date
      t.timestamps
    end
  end
end
