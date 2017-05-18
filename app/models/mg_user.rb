class MgUser < ActiveRecord::Base
	    attr_accessor :password 

  before_save :encrypt_password
  before_update :encrypt_password
  
  validates_confirmation_of :password
 
  validates_presence_of :password, :on => :create

  validates_presence_of :user_name
  #validates_uniqueness_of :user_name 
  validates_uniqueness_of :user_name, scope: :mg_school_id, conditions: -> { where(is_deleted: false) }

  belongs_to :mg_school
  # belongs_to :mg_user_roles
      has_many :mg_custom_fields_datas


      has_many :mg_curriculums


    has_many :mg_addresses

  has_many :mg_addresses , :dependent => :destroy
    accepts_nested_attributes_for :mg_addresses

    has_many :mg_emails , :dependent => :destroy
    accepts_nested_attributes_for :mg_emails

    has_many :mg_phones , :dependent => :destroy
    accepts_nested_attributes_for :mg_phones

    has_many :mg_students , :dependent => :destroy
    accepts_nested_attributes_for :mg_students

    has_many :mg_guardians , :dependent => :destroy
    accepts_nested_attributes_for :mg_guardians

    has_many :mg_employees , :dependent => :destroy
    accepts_nested_attributes_for :mg_employees

    has_many :mg_user_roles , :dependent => :destroy
    accepts_nested_attributes_for :mg_user_roles

    # has_many :mg_students,:dependent => :destroy
    # accepts_nested_attributes_for :mg_students

    # has_many :mg_guardians,:dependent => :destroy
    # accepts_nested_attributes_for :mg_guardians



  def self.authenticate(user_name, password )
    user = find_by_user_name(user_name)
 
    if user && user.hashed_password == BCrypt::Engine.hash_secret(password, user.salt)
      user
    else
      nil
    end
  end
  
def self.authenticateUser(user_name, password, school_id )
    user = find_by_user_name(user_name)
 
    if user && user.hashed_password == BCrypt::Engine.hash_secret(password, user.salt) &&  user.mg_school_id==school_id
      user
    else
      nil
    end
  end

 #Commented By Bindhu
  # def self.authenticateUsers(user_name, password, school_id, is_deleted )

  #   user = find_by_user_name(user_name)
 
  #   if user && user.hashed_password == BCrypt::Engine.hash_secret(password, user.salt) &&  user.mg_school_id==school_id &&  is_deleted==false
  #     user
  #   else
  #     nil
  #   end
  # end

 #Added By Bindhu
   def self.authenticateUsers(user_name, password, is_deleted )

    user = find_by_user_name(user_name)
 
    if user && user.hashed_password == BCrypt::Engine.hash_secret(password, user.salt) && is_deleted==false
      user
    else
      nil
    end
  end
   def self.authenticateUsersWithSchool(user_name, password, is_deleted, mg_school_id )

    user = find_by_user_name(user_name)
 
    if user && user.hashed_password == BCrypt::Engine.hash_secret(password, user.salt) && user.is_deleted==false && user.mg_school_id==mg_school_id
      user
    else
      nil
    end
  end
#Bindhu Work end


  def encrypt_password

    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.hashed_password = BCrypt::Engine.hash_secret(password, salt)
    end
  end




end
