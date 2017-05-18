class AddAmountToMgAccountTransaction < ActiveRecord::Migration
  def change
    add_column :mg_account_transactions, :amount, :integer
  end
end
