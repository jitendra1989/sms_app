class AddTypeToMgFinanceTransactionDetail < ActiveRecord::Migration
  def change
    add_column :mg_finance_transaction_details, :type, :string
  end
end
