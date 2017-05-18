class MgStudent < ActiveRecord::Base

	#belongs_to :mg_user
   # before_create :randomize_student_image_file_name
   #  before_save :randomize_student_image_file_name
   #  before_update :randomize_student_image_file_name
    #before_save :randomize_student_image_file_name
    #before_update :randomize_student_image_file_name


    has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "adminImage.png"
    validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

    has_many :mg_exam_scores,:dependent => :destroy
  	accepts_nested_attributes_for :mg_exam_scores

    belongs_to :mg_batch
    belongs_to :mg_student_catagory
    belongs_to :mg_user
    belongs_to :mg_school
    belongs_to :mg_course
   
    has_many :mg_student_attendances
    has_many :mg_finance_fees
    has_many :mg_previous_educations

scope :by_first_name, lambda{where(:is_deleted=>0).order(:first_name)}
  #scope :active,lambda{where(:is_deleted=>0).joins(:mg_course).select("`mg_batches`.*,CONCAT(mg_courses.code,'-',mg_batches.name) as course_full_name",:order=>"course_full_name")}

    has_many :mg_finance_transactions
    has_many :mg_student_guardians
    has_many :mg_guardians, through: :mg_student_guardians
    accepts_nested_attributes_for :mg_guardians
    
    has_many :mg_fee_collection_particulars
    has_many :mg_exam_scroes
    has_many :mg_assessment_scores
    delegate :course_batch_name,:to => :mg_batch

    def student_name
     "#{first_name}  #{last_name}"
    end

    def student_full_name
      "#{admission_number}#{" - "}#{first_name} #{last_name}"
    end

    def course_batch_name_student
      "#{course_batch_name}"
    end

    # private

    # def randomize_student_image_file_name
    #   #puts " FFF--Student image editing is going to calll "  

    #   extension = File.extname(avatar_file_name).downcase
    #   user_iid = self.mg_user_id
    #   fine_naam = user_iid.to_s + "_student_profile#{extension}"
    #   #puts "Step -- 1 file extension"
    #   #puts extension.inspect
    #   #puts "Student is"
    #   #puts fine_naam
    #   #puts "Step -- 2 file extension"
    #   self.avatar.instance_write(:file_name, fine_naam)
    # end

    def randomize_student_image_file_name
      #puts " FFF--Student image editing is going to calll "  

      # extension = File.extname(avatar_file_name).downcase
      # user_iid = self.mg_user_id
      # fine_naam = user_iid.to_s + "_student_profile#{extension}"
      # #puts "Step -- 1 file extension"
      # #puts extension.inspect
      # #puts "Student is"
      # #puts fine_naam
      # #puts "Step -- 2 file extension"
      # self.avatar.instance_write(:file_name, fine_naam)
    end
  def self.students(users_name,mg_user_id,mg_student,mg_school_id,session_user,mg_batch_id)
    @users_name = users_name
    @mg_user_id = mg_user_id.id
    @student_name = mg_student
    @mg_school_id = mg_school_id
    @session_user = session_user
    @mg_batch_id = mg_batch_id    
    #@student_category_id = student_category_id
    MgStudent.create(:admission_number=>@users_name,:mg_user_id=>@mg_user_id,:nationality=>@student_name.try(:nationality),:first_name=>@student_name.try(:first_name),:middle_name=>@student_name.try(:middle_name),:last_name=>@student_name.try(:last_name),
    :mg_course_id=>@student_name.mg_course_id,:date_of_birth=>@student_name.try(:date_of_birth),:gender=>@student_name.try(:gender),:blood_group=>@student_name.try(:blood_group),:birth_place=>@student_name.try(:birth_place),:mg_batch_id=>@mg_batch_id,
    :language=>@student_name.try(:language),:religion=>@student_name.try(:religion),:updated_by=>@session_user,:is_deleted=>0,:mg_school_id=>@mg_school_id,:created_by=>@session_user,:mg_student_admission_id=>@student_name.id,:mg_student_catagory_id=>@student_name.mg_student_category_id)
  end
end
