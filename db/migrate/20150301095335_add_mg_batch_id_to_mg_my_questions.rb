class AddMgBatchIdToMgMyQuestions < ActiveRecord::Migration
  def change
    add_column :mg_my_questions, :mg_batch_id, :integer
  end
end
