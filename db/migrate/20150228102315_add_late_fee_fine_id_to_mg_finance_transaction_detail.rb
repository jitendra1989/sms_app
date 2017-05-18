class AddLateFeeFineIdToMgFinanceTransactionDetail < ActiveRecord::Migration
  def change
    add_column :mg_finance_transaction_details, :late_fee_fine_id, :integer
  end
end
