class MgSportsBedAssignment < ActiveRecord::Base
 def self.myprm(admitted_date,discharge_date)
    @admitted_date=admitted_date
    @discharge_date=discharge_date
    puts admitted_date
    puts discharge_date
  end

  validates :admitted_time,:discharge_time, :overlap => {
                            :scope => ["mg_sports_bed_details_id","mg_school_id"],
                            :query_options => {:active => nil,:date_validation=>nil} }
  scope :active, -> { where(:is_deleted => false) }                                          
  # scope :date_validation, -> { where('`mg_sports_bed_assignments`.`admitted_date` <= ? OR `mg_sports_bed_assignments`.`discharge_date` >= ?',"#{@admitted_date}","#{@discharge_date}")}
  # scope :date_validation, -> { where('`mg_sports_bed_assignments`.`admitted_date` <= ? AND `mg_bed_assignments`.`discharge_date` >= ?',"#{@admitted_date}","#{@discharge_date}")}
  scope :date_validation, -> { where('(`mg_sports_bed_assignments`.`admitted_date` <= ? AND `mg_sports_bed_assignments`.`discharge_date` >= ?) OR (`mg_sports_bed_assignments`.`admitted_date` <= ? AND `mg_sports_bed_assignments`.`discharge_date` >= ?) OR (`mg_sports_bed_assignments`.`admitted_date` >= ? AND `mg_sports_bed_assignments`.`discharge_date` <= ?)',"#{@admitted_date}","#{@admitted_date}","#{@discharge_date}","#{@discharge_date}","#{@admitted_date}","#{@discharge_date}")}

end
