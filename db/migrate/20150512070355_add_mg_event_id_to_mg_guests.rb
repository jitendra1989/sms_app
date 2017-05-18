class AddMgEventIdToMgGuests < ActiveRecord::Migration
  def change
    add_column :mg_guests, :mg_event_id, :integer
  end
end
