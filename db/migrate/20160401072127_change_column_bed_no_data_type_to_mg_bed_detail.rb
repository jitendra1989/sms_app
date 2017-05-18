class ChangeColumnBedNoDataTypeToMgBedDetail < ActiveRecord::Migration
  def change
    change_column :mg_bed_details, :bed_no, :string
  end
end
