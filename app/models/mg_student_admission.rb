class MgStudentAdmission < ActiveRecord::Base
  validates :first_name, :uniqueness => {:scope => [:last_name, :guardian_name,:date_of_birth],
  conditions: -> { where(is_deleted: false) }}
  
end
