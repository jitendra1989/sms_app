class AddMgItemTypeIdToMgItemConsumption < ActiveRecord::Migration
  def change
    add_column :mg_item_consumptions, :mg_item_type_id, :integer
  end
end
