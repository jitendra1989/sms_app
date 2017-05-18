class AddPaymentModeToMgFinanceTransaction < ActiveRecord::Migration
  def change
    add_column :mg_finance_transactions, :payment_mode, :string
    add_column :mg_finance_transactions, :date_of_cheque, :date
    add_column :mg_finance_transactions, :date_of_draft, :date
    add_column :mg_finance_transactions, :cheque_number, :string
    add_column :mg_finance_transactions, :draft_number, :string
    add_column :mg_finance_transactions, :bankname_and_branch, :string

  end
end
