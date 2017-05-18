class CreateMgActionRequireds < ActiveRecord::Migration
  def change
    create_table :mg_action_requireds do |t|
      t.text :action_required
      t.text :description
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
