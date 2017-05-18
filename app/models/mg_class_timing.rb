class MgClassTiming < ActiveRecord::Base
    # validates :start_time, :uniqueness => {:scope => :mg_weekday_id} 
    # validates :end_time, :uniqueness => {:scope => :mg_weekday_id} 
  	validates :start_time, :end_time, :overlap => {:scope => ["mg_weekday_id","mg_wing_id"],:query_options => {:active => nil} }
    scope :active, -> { where(:is_deleted => false) }

  	belongs_to :mg_batch
  	belongs_to :mg_weekday
  	belongs_to :mg_school
    has_many :mg_time_table_change_entries
    # has_many :mg_time_table_entries, :through => :mg_class_timings_id


  	delegate :weekday, :to => :mg_weekday

    

  	def weekday_id
  		"#{weekday}"
  	end

  	def weekday_name
    weekday_hash=Hash.new
    weekday_hash[0]= "Sunday"
    weekday_hash[1]= "Monday"
    weekday_hash[2]= "Tuesday" 
    weekday_hash[3]= "Wednesday" 
    weekday_hash[4]= "Thursday"
    weekday_hash[5]= "Friday"
    weekday_hash[6]= "Saturday"
  		"#{weekday_hash[weekday.to_i]}"
  	end

   
  	
 end
