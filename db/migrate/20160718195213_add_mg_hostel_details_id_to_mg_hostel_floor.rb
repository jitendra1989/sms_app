class AddMgHostelDetailsIdToMgHostelFloor < ActiveRecord::Migration
  def change
    add_column :mg_hostel_floors, :mg_hostel_details_id, :integer
  end
end
