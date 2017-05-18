class CreateMgUserRoles < ActiveRecord::Migration
  def change
    create_table :mg_user_roles do |t|
    	t.integer :mg_user_id, index: true
      t.integer :mg_role_id, index: true

      # Audit Fields
      # t.boolean :is_deleted
      # t.integer :mg_school_id
      # t.integer :created_by
      # t.integer :updated_by
      t.timestamps
    end
    add_index :mg_user_roles, ["mg_user_id","mg_role_id"]

  end
end
