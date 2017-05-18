class MgCheckUpSchedule < ActiveRecord::Base
  has_many :mg_check_up_schedule_records

  	def self.myprm(date)
	    @date=date
    end
    validates :start_time,:end_time, :overlap => {
                              :scope => ["mg_doctor_id","mg_school_id"],
                              :query_options => {:active => nil,:date_validation=>nil} }
    scope :active, -> { where(:is_deleted => false) }                                          
    scope :date_validation, -> { where('`mg_check_up_schedules`.`date` <= ? AND `mg_check_up_schedules`.`date` >= ?',"#{@date}","#{@date}")}
end
