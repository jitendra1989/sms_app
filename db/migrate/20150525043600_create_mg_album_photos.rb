class CreateMgAlbumPhotos < ActiveRecord::Migration
  def change
    create_table :mg_album_photos do |t|
      t.integer :mg_album_id
      t.attachment :photo
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
