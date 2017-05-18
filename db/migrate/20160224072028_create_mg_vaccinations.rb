class CreateMgVaccinations < ActiveRecord::Migration
  def change
    create_table :mg_vaccinations do |t|
    	t.string :name
    	t.float :age_recommended
    	t.text :description
      	t.integer :mg_school_id
      	t.boolean :is_deleted
      	t.integer :created_by
      	t.integer :updated_by
      	t.timestamps
    end
  end
end

