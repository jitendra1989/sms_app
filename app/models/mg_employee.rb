class MgEmployee < ActiveRecord::Base

    # before_save :randomize_employee_image_file_name
    # before_update :randomize_employee_image_file_name

    #validation for uniqueness of employee by Bindhu start
    validates :first_name, :uniqueness => {:scope => [:last_name, :father_name,:date_of_birth]}
    #validation for uniqueness of employee by Bindhu end


	has_many :mg_addresses,:dependent => :destroy
  	accepts_nested_attributes_for :mg_addresses

    

    has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "adminImage.png"
    validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/

    belongs_to :mg_employee_category
    belongs_to :mg_employee_department
    belongs_to :mg_employee_grade
    belongs_to :mg_employee_position
    belongs_to :mg_user
    belongs_to :mg_school
    belongs_to :mg_employee_type

    has_many :mg_batches
    has_many :mg_time_table_entries
    has_many :mg_employee_leaves

    has_many :mg_employee_attendances,:dependent => :destroy
    accepts_nested_attributes_for :mg_employee_attendances


    has_many :mg_employee_subjects,:dependent => :destroy
    accepts_nested_attributes_for :mg_employee_subjects


    has_many :mg_phones,:dependent => :destroy
    accepts_nested_attributes_for :mg_phones

    delegate :department_name,:to => :mg_employee_department
    delegate :category_name,:to => :mg_employee_category
    delegate :user_name,:to => :mg_user

    #payslip start
    has_many :mg_employee_payslips , :dependent => :destroy
    accepts_nested_attributes_for :mg_employee_payslips

    has_many :mg_bank_account_details,:dependent => :destroy
    accepts_nested_attributes_for :mg_bank_account_details

    has_many :mg_employee_grade_components
    has_many :mg_employee_payslip_details

    #payslip end


    # def image_file=(input_data)
    #     self.photo_file_name = input_data.original_filename
    #     self.photo_content_type = input_data.content_type.chomp
    #     self.photo_data = input_data.read
    # end

   

    def employee_name
        "#{first_name} #{middle_name} #{last_name}"
        
    end

    def dept_name
        "#{department_name}"
    end

    def category_names
         "#{category_name}"
    end

    def employee_user_name
        "#{user_name}"
    end

    def employee_full_name_with_number
      "#{employee_number}#{" - "}#{first_name} #{last_name}"
    end
    
end
