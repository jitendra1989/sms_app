class AddPhotoToMgGuardian < ActiveRecord::Migration
  def change
  	add_attachment :mg_guardians, :photo
  end
end
