class AddColumnRemarkToMgFomTransportBooking < ActiveRecord::Migration
  def change
    add_column :mg_fom_transport_bookings, :remark, :text
  end
end
