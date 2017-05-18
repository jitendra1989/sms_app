class MgDocumentManagement < ActiveRecord::Base
		#    has_attached_file :f, styles: {
  #   thumb: '100x100>',
  #   square: '200x200#',
  #   medium: '300x300>'
  # }


  # has_attached_file :image,
  # # :styles => {:thumb => '120x120>', :large => '640x480>' },
  # # :default_style => :thumb,
  # :url => "/system/:class/:attachment/:id/:style/:basename.:extension",
  # :path => ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension"

  
	has_attached_file :file
 	validates_attachment_content_type :file, :content_type => []
  # validates_attachment_size :file, :less_than => 25.megabytes



    belongs_to :mg_inventory_item
end
