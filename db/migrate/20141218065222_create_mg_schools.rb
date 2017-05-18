class CreateMgSchools < ActiveRecord::Migration
  def change
    create_table :mg_schools do |t|

      t.string :school_name
      t.string :school_code
      t.string :address_line1
      t.string :address_line2
      # not mention in specification but we required those fields also
      t.string :country
      t.integer :country_code
      t.attachment :logo
      # not mention in specification but we required those fields also

      # start time and end time
      t.string :start_time
      t.string :end_time
      # start time and end time


      t.string :street
      t.string :city
      t.string :state
      t.integer :pin_code
      t.string :landmark
      t.integer :mobile_number
      t.string :email_id
      t.integer :fax_number
      t.string :language
      t.string :date_format
      t.string :timezone
      t.string :currency_type
      t.string :affilicated_to
      t.string :grading_system
      t.binary :school_logo
      t.integer :reg_num

      t.boolean :is_active
      
      #Audit Fields
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by 

      t.timestamps
    end
  end
end
