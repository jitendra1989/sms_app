class MgSubject < ActiveRecord::Base
	# validates_numericality_of :subject_code
	# validates_numericality_of :max_weekly_class
	# validates_presence_of :subject_code
	# validates_presence_of :max_weekly_class
    belongs_to :mg_school

	has_many :mg_batch_subjects
	has_many :mg_batch_syllabuses
	has_many :mg_fa_groups_subjects
	has_many :mg_exams
	has_many :mg_employee_subjects
    has_many :mg_curriculums
	has_many :mg_time_table_entries

	validates_presence_of :subject_name
    validates :max_weekly_class, numericality: { only_integer: true }

    belongs_to :mg_course
    delegate :course_name,:to => :mg_course
    delegate :course_batch_name,:to => :mg_batch

    def subject_course_name
    	"#{course_name}"
    	
    end

 	def student_name1
        "#{first_name}  #{last_name}"
        
    end

	 def course_batch_name_student
      "#{course_batch_name}"
    end
end
