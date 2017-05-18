class AddTransactionTypeToMgAccountTransactions < ActiveRecord::Migration
  def change
    add_column :mg_account_transactions, :transaction_type, :string
  end
end
