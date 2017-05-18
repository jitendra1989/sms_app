class AddMgResourceInventoryIdToMgBooksTransaction < ActiveRecord::Migration
  def change
    add_column :mg_books_transactions, :mg_resource_inventory_id, :integer
    add_column :mg_books_transactions, :user_type, :string

  end
end
