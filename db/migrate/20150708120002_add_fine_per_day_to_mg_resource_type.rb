class AddFinePerDayToMgResourceType < ActiveRecord::Migration
  def change
    add_column :mg_resource_types, :fine_per_day, :float
  end
end
