class MgEmployeeBiometricAttendance < ActiveRecord::Base
  	validates :check_in, :check_out,:overlap => {:scope => ["mg_school_id", "date",  "mg_employee_id"],:query_options => {:active => nil}}
   	 scope :active, -> { where(:is_deleted => false) }
	
 end
