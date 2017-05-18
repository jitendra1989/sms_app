class MgStudentCategory < ActiveRecord::Base
	belongs_to :mg_school
	
	has_many :mg_fee_particulars
	has_many :mg_fee_collection_particulars
	
	has_many :mg_students,:dependent => :destroy
	accepts_nested_attributes_for :mg_students
end
