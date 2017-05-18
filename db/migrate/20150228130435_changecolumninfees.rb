class Changecolumninfees < ActiveRecord::Migration
  def change
  	rename_column :mg_finance_transaction_details,:type,:detail_type
  	
  end
end
