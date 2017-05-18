class MgCourse < ActiveRecord::Base

	belongs_to :mg_school
    has_many :mg_class_designations
    has_many :mg_students
    has_many :mg_cce_weightages_courses
    has_many :mg_course_observation_groups
    has_many :mg_ranking_levels
	has_many :mg_batches 
	has_many :mg_batch_groups
  has_many :mg_subjects
    #accepts_nested_attributes_for :mg_batches
 has_many :mg_cce_weightages_courses,:dependent => :destroy
 accepts_nested_attributes_for :mg_cce_weightages_courses

 has_many :mg_class_designations,:dependent => :destroy
 accepts_nested_attributes_for :mg_class_designations

has_many :mg_ranking_levels , :dependent => :destroy
    accepts_nested_attributes_for :mg_ranking_levels



def full_name
    "#{course_name} #{section_name}"
  end


  def active_batches
    self.mg_batches.all
  end

  def has_batch_groups_with_active_batches
    batch_groups = self.mg_batch_groups
    if batch_groups.empty?
      return false
    else
      batch_groups.each do|b|
        return true if b.has_active_batches==true
      end
    end
    return false
  end



end
