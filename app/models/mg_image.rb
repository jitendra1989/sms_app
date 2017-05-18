class MgImage < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  mount_uploader :video, ImageUploader
  
  belongs_to :mg_alumni_photo_gallery  
end
