class CreateMgLanguages < ActiveRecord::Migration
  def change
    create_table :mg_languages do |t|

      t.integer :mg_user_id
      t.string :language_name

      t.string :read
      t.string :write
      t.string :speak

      t.integer :mg_school_id
      t.boolean :is_deleted
      
      t.integer :created_by
      t.integer :updated_by


      t.timestamps
    end
  end
end
