class ChangeDatatypeFom < ActiveRecord::Migration
  def change

   change_table :mg_fom_transport_bookings do |t|
      t.change :way_mode, :string
 
  end
  end
end
