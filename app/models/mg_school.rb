class MgSchool < ActiveRecord::Base

    # before_create :randomize_image_file_name

    validates :school_name,:school_code, :address_line1, :city, :state,:pin_code, :country,:mobile_number,:email_id,:fax_number,:date_format,:timezone,:currency_type,:affilicated_to,:grading_system, presence: true
    validates :pin_code,numericality: { only_integer: true }
    validates :email_id, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }

    
    has_attached_file :logo, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "logo.jpg"
    validates_attachment_content_type :logo,:content_type =>/\Aimage\/.*\Z/

    def schedule_command
        puts "It is for schedule job"
    end


    has_many :mg_cce_grades
    has_many :mg_cce_weightages
    has_many :mg_cce_weightages_courses
    has_many :mg_class_designations
    has_many :mg_class_timings
    has_many :mg_common_custom_fields
    has_many :mg_employee_categories
    has_many :mg_employee_leaves
    has_many :mg_employee_subjects
    has_many :mg_events
    has_many :mg_event_types
    has_many :mg_exams
    has_many :mg_exam_groups
    has_many :mg_exam_scroes
    has_many :mg_fa_criterias
    has_many :mg_fa_groups
    has_many :mg_fa_groups_subjects
    has_many :mg_fee_categories
    has_many :mg_fee_category_batches
    has_many :mg_fee_collections
    has_many :mg_fee_collection_discounts
    has_many :mg_fee_collection_particulars
    has_many :mg_fee_discounts
    has_many :mg_fee_fines
    has_many :mg_fee_fine_dues
    has_many :mg_fee_particulars
    has_many :mg_finance_fees
    has_many :mg_finance_transactions
    has_many :mg_grading_levels
    has_many :mg_grouped_exams
    has_many :mg_mail_statuses
    has_many :mg_notifications
    has_many :mg_observations
    has_many :mg_observation_groups
    has_many :mg_ranking_levels
    has_many :mg_student_attendances
    has_many :mg_student_categories
    has_many :mg_subjects
    has_many :mg_time_tables
    has_many :mg_weekdays
    has_many :mg_batch_subjects
    has_many :mg_cce_exam_categories
    has_many :mg_addresses
    has_many :mg_assessment_scores
    has_many :mg_course_observation_groups
    has_many :mg_curriculums
    has_many :mg_custom_fields_datas
    has_many :mg_descriptive_indicators

    has_many :mg_courses,:dependent => :destroy
    accepts_nested_attributes_for :mg_courses

    has_many :mg_batches,:dependent => :destroy
    accepts_nested_attributes_for :mg_batches

    has_many :mg_employees,:dependent => :destroy
    accepts_nested_attributes_for :mg_employees

    has_many :mg_students,:dependent => :destroy
    accepts_nested_attributes_for :mg_students

    has_many :mg_guardians,:dependent => :destroy
    accepts_nested_attributes_for :mg_guardians

    has_many :mg_users,:dependent => :destroy
    accepts_nested_attributes_for :mg_users

    #def image_file=(input_data)
    # self.filename = input_data.original_filename
   #  self.content_type = input_data.content_type.chomp
   #  self.school_logo = input_data.read
  #end


  def randomize_image_file_name
      puts "School image editing is going to calll "  

      # extension = File.extname(image_file_name).downcase
      # self.image.instance_write(:file_name, "#{ActiveSupport::SecureRandom.hex(8)}#{extension}")
  end
end
