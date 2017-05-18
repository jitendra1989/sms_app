class MgAlumniPhotoGallery < ActiveRecord::Base
  has_many :mg_images, dependent: :destroy
  has_many :mg_alumni_student_associations
  has_attached_file :image, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
  }
end
