class AddMgInventoryFineParticularIdToMgFeeFineParticular < ActiveRecord::Migration
  def change
    add_column :mg_fee_fine_particulars, :mg_inventory_fine_particular_id, :integer
  end
end
