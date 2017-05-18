class AddAccountIdToMgFeeParticular < ActiveRecord::Migration
  def change
  	add_column :mg_fee_particulars, :mg_account_id, :integer
  end
end
