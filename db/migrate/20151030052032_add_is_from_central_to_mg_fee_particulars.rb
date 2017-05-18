class AddIsFromCentralToMgFeeParticulars < ActiveRecord::Migration
  def change
  	add_column :mg_fee_particulars, :is_to_central, :boolean
  	add_column :mg_fee_fine_particulars, :is_to_central, :boolean
  end
end
