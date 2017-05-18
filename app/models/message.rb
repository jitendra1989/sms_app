class Message 
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  attr_accessor :to_user_id, :subject, :description,:user_check, :from_user_id, :is_deleted, :status, :mg_school_id
  validates :subject, :description, :presence => true
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end
end