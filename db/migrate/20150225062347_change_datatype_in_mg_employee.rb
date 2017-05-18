class ChangeDatatypeInMgEmployee < ActiveRecord::Migration
  def change
  	 change_column :mg_employees, :emergency_contact_number, :string
  	 
  end
end
