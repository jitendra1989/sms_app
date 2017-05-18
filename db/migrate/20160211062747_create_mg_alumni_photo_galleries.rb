class CreateMgAlumniPhotoGalleries < ActiveRecord::Migration
  def change
    create_table :mg_alumni_photo_galleries do |t|
      t.string :name
      t.text :description
      t.integer :mg_alumni_id
      t.integer :mg_user_id
      t.string :status
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end

