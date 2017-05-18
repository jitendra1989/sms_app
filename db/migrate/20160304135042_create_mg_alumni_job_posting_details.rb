class CreateMgAlumniJobPostingDetails < ActiveRecord::Migration
  def change
    create_table :mg_alumni_job_posting_details do |t|
      t.string :position
      t.text :job_description
      t.string :minimum_qualification
      t.integer :minimum_experience_required
      t.text :company
      t.string :company_website
      t.integer :relevant_experience
      t.string :alumni_id
      t.string :referral_code
      t.string :functional_area
      t.string :technical_skills
      t.string :soft_skills
      t.string :salary
      t.date :interview_date
      t.date :last_date_of_application
      t.string :status

      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end


