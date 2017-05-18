class AddIsThereADelayToMgBooksTransaction < ActiveRecord::Migration
  def change
    add_column :mg_books_transactions, :is_there_a_delay, :boolean
    add_column :mg_books_transactions, :is_it_returned_as_was_taken, :boolean
    add_column :mg_books_transactions, :is_fine_applicable, :boolean
    add_column :mg_books_transactions, :no_of_days_delayed, :boolean
    add_column :mg_books_transactions, :amount, :boolean

  end
end
