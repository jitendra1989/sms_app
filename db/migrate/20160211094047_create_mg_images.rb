class CreateMgImages < ActiveRecord::Migration
  def change
    create_table :mg_images do |t|
      t.integer :mg_alumni_photo_gallery_id
      t.string :image
      t.string :video
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end

