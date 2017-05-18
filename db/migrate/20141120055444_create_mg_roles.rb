class CreateMgRoles < ActiveRecord::Migration
  def change
    create_table :mg_roles do |t|
      t.string :role_name
      t.string :description
      
      # Audit Fields
      # t.boolean :is_deleted
      # t.integer :mg_school_id
      # t.integer :created_by
      # t.integer :updated_by
      t.timestamps
    end
  end
end
