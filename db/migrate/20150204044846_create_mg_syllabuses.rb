class CreateMgSyllabuses < ActiveRecord::Migration
  def change
    create_table :mg_syllabuses do |t|
      t.integer :mg_subject_id
      t.string :name
      t.text :description

      
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by
      t.boolean :is_deleted

      t.timestamps
    end
  end
end
