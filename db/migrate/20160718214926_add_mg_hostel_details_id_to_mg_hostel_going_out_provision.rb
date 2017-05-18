class AddMgHostelDetailsIdToMgHostelGoingOutProvision < ActiveRecord::Migration
  def change
    add_column :mg_hostel_going_out_provisions, :mg_hostel_details_id, :integer
  end
end
