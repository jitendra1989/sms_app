class AddDateToMgInventoryProjection < ActiveRecord::Migration
  def change
    add_column :mg_inventory_projections, :date, :date
  end
end
