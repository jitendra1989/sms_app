class CreateMgAlumnis < ActiveRecord::Migration
  def change
    create_table :mg_alumnis do |t|
      t.string :first_name
      t.string :last_name
      t.string :middle_name
      t.date :date_of_birth
      t.string :gender
      t.integer :phone_number, :integer, :limit => 8
      t.integer :mobile_number, :integer, :limit => 8
      t.string :email_id
      t.text :current_location
      t.text :current_address
      t.string :current_profession
      t.string :designation
      t.string :current_organization
      t.text :hobbies
      t.string :user_name
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by
      t.integer :mg_school_id
      t.integer :mg_user_id
      t.string :status
      t.boolean :is_name_sharable
      t.boolean :is_email_id_sharable
      t.boolean :is_mobile_no_sharable
      t.string :admission_number
      t.boolean :is_programme_searchable
      t.boolean :is_passing_out_searchable
      t.boolean :is_specialization_searchable
      t.boolean :is_current_location_searchable
      t.boolean :is_current_profession_searchable
      t.boolean :is_current_designation_searchable
      t.boolean :is_current_organization_searchabler

      t.timestamps
    end
  end
end

