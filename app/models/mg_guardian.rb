class MgGuardian < ActiveRecord::Base
	belongs_to :mg_user
	belongs_to :mg_school

	has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "adminImage.png"
    validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/

	has_many :mg_student_guardians
	has_many :mg_student , through: :mg_student_guardians
end
