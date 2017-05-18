class CreateMgGuardians < ActiveRecord::Migration
  def change
    create_table :mg_guardians do |t|

      t.integer :mg_ward_id
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :relation
      t.date :dob
      t.integer :mg_country_id
      t.string :occupation
      t.string :income
      t.string :education
      t.integer :mg_user_id
      t.integer :mg_student_id

      #audit fields
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by
      t.timestamps
    end
  end
end
