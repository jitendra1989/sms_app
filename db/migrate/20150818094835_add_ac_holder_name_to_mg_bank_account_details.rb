class AddAcHolderNameToMgBankAccountDetails < ActiveRecord::Migration
  def change
    add_column :mg_bank_account_details, :ac_holder_name, :string
  end
end
