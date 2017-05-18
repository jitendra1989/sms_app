class MgAlbumPhoto < ActiveRecord::Base
has_attached_file :photo, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'

  }#,

  # :url => "/controllers/:style/:basename.:extension",
  #        :path => ":rails_root/public/controllers/:style/:basename.:extension",
  #        :default_url => "/controllers/:style/example_data.csv"


  # has_attached_file :image,
  # # :styles => {:thumb => '120x120>', :large => '640x480>' },
  # # :default_style => :thumb,
  # :url => "/system/:class/:attachment/:id/:style/:basename.:extension",
  # :path => ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension"

  
	# has_attached_file :photo
 	validates_attachment_content_type :photo, :content_type => []
  # validates_attachment_size :file, :less_than => 25.megabytes
end
