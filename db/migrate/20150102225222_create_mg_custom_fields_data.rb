class CreateMgCustomFieldsData < ActiveRecord::Migration
  def change
    create_table :mg_custom_fields_data do |t|
      t.string :mg_user_id
      t.string :mg_custom_field_id
      t.string :value


      #Audit fields
      t.string :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
