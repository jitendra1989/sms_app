class AddMgLaboratoryItemTypeIdToMgItemConsumption < ActiveRecord::Migration
  def change
    add_column :mg_item_consumptions, :mg_laboratory_item_type_id, :integer
  end
end
