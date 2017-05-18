class ChangeDatatypeInMgSchool < ActiveRecord::Migration
  def change
  	change_column :mg_schools, :reg_num, :string
  	 change_column :mg_schools, :mobile_number, :string
  	 change_column :mg_schools, :fax_number, :string
  end
end
