class ChangeGuestDetailsInMgGuests < ActiveRecord::Migration
    def up
    change_column :mg_guests, :guest_details, :text
  end

  def down
    change_column :mg_guests, :guest_details, :string
  end
end
