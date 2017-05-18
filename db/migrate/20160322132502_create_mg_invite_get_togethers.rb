class CreateMgInviteGetTogethers < ActiveRecord::Migration
  def change
    create_table :mg_invite_get_togethers do |t|
      t.integer :mg_wing_id
      t.string :passout_year
      t.integer :mg_alumni_get_together_id
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
