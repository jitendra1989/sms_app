class AddPurposeStatusReasonToMgCentralAccountTransaction < ActiveRecord::Migration
  def change
    add_column :mg_central_account_transactions, :purpose, :text
    add_column :mg_central_account_transactions, :status, :string
    add_column :mg_central_account_transactions, :Reason, :text
  end
end
