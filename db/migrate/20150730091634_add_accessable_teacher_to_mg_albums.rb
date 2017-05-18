class AddAccessableTeacherToMgAlbums < ActiveRecord::Migration
  def change
    add_column :mg_albums, :accessable_teacher, :boolean
    add_column :mg_user_albums, :accessable_teacher, :boolean
    
  end
end
