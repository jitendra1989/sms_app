class AddAvailabilityToMgHostelRoom < ActiveRecord::Migration
  def change
    add_column :mg_hostel_rooms, :availability, :integer
  end
end
