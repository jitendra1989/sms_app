class CreateMgPollData < ActiveRecord::Migration
  def change
    create_table :mg_poll_data do |t|
      t.integer :mg_question_id
      t.integer :mg_alumni_user_id
      t.integer :answer
      t.integer :created_by
      t.integer :updated_by
      t.boolean :is_deleted
      t.integer :mg_school_id

      t.timestamps
    end
  end
end
