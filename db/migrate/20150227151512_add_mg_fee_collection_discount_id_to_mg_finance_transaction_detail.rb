class AddMgFeeCollectionDiscountIdToMgFinanceTransactionDetail < ActiveRecord::Migration
  def change
    add_column :mg_finance_transaction_details, :mg_fee_collection_discount_id, :integer
    add_column :mg_finance_transaction_details, :mg_school_id, :integer
    add_column :mg_finance_transaction_details, :created_by, :integer
    add_column :mg_finance_transaction_details, :updated_by, :integer
    add_column :mg_finance_transaction_details, :is_deleted, :boolean
  end
end
