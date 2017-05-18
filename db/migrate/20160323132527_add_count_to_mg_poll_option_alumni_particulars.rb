class AddCountToMgPollOptionAlumniParticulars < ActiveRecord::Migration
  def change
    add_column :mg_poll_option_alumni_particulars, :count, :integer
  end
end
