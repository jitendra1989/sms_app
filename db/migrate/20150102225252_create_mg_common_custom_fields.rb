class CreateMgCommonCustomFields < ActiveRecord::Migration
  def change
    create_table :mg_common_custom_fields do |t|
      t.string :model_name
      t.string :name
      t.string :text_data
      t.string :data_type



      #Audit fields
      t.string :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
