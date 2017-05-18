class AddTransactionTypeAndAmountTransferTypeToMgAccountTransaction < ActiveRecord::Migration
  def change
    #add_column :mg_account_transactions, :transaction_type, :string
    add_column :mg_account_transactions, :amount_transfer_type, :string
    rename_column :mg_account_transactions, :from_module, :for_module
  end
end
