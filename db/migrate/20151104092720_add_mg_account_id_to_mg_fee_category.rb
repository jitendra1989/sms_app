class AddMgAccountIdToMgFeeCategory < ActiveRecord::Migration
  def change
    add_column :mg_fee_categories, :mg_account_id, :integer
  end
end
