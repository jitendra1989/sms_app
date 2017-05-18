class AddModuleTypeToMgBedDetail < ActiveRecord::Migration
  def change
    add_column :mg_bed_details, :module_type, :string
  end
end
