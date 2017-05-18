class AddMgItemConsumptionToMgFeeFineParticular < ActiveRecord::Migration
  def change
    add_column :mg_fee_fine_particulars, :mg_item_consumption_id, :integer
  end
end
