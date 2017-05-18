class AddModuleTypeToMgBedAssignment < ActiveRecord::Migration
  def change
    add_column :mg_bed_assignments, :module_type, :string
  end
end
