class AddFeesFromToMgFinanceTransaction < ActiveRecord::Migration
  def change
    add_column :mg_finance_transactions, :fees_from, :string
  end
end
