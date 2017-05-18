class CreateMgBooksTransactions < ActiveRecord::Migration
  def change
    create_table :mg_books_transactions do |t|
      t.integer :mg_student_id
      t.date :start_date
      t.date :end_date
      t.integer :issued_by
      t.integer :received_by
      t.string :return_book_condition
      t.integer :mg_books_inventory_id
      t.string :status
      t.date :due_date
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by
      t.timestamps
    end
  end
end
