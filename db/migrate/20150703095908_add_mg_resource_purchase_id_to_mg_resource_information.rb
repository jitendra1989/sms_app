class AddMgResourcePurchaseIdToMgResourceInformation < ActiveRecord::Migration
  def change
    add_column :mg_resource_informations, :mg_resource_purchase_id, :integer
  end
end
