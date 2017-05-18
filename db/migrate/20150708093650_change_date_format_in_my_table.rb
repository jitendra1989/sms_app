class ChangeDateFormatInMyTable < ActiveRecord::Migration
  def change
    change_column :mg_books_transactions, :is_fine_applicable, :string
  end
end
