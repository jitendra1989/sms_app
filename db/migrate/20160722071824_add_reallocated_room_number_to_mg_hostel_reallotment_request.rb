class AddReallocatedRoomNumberToMgHostelReallotmentRequest < ActiveRecord::Migration
  def change
    add_column :mg_hostel_reallotment_requests, :reallocated_room__number, :string
  end
end
