class CreateMgParticularTypes < ActiveRecord::Migration
  def change
    create_table :mg_particular_types do |t|
      t.string :particular_name
      t.string :description
      t.integer :mg_fee_category_id

      
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
