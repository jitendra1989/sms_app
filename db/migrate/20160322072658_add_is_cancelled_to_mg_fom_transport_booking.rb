class AddIsCancelledToMgFomTransportBooking < ActiveRecord::Migration
  def change
    add_column :mg_fom_transport_bookings, :is_cancelled, :boolean
  end
end
