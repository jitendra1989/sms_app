class AddMgUserIdToMgHostelFloor < ActiveRecord::Migration
  def change
    add_column :mg_hostel_floors, :mg_user_id, :integer
  end
end
