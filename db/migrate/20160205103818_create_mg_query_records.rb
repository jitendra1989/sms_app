class CreateMgQueryRecords < ActiveRecord::Migration
  def change
    create_table :mg_query_records do |t|
      t.string :query_number
      t.string :caller_name
      t.string :phone_number
      t.integer :mg_caller_category_fom_id
      t.text :query
      t.integer :mg_fom_query_record_id
      t.text :response_given
      t.text :follow_up_action
      t.text :action_required
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
