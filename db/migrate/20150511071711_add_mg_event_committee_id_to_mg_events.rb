class AddMgEventCommitteeIdToMgEvents < ActiveRecord::Migration
  def change
    add_column :mg_events, :mg_event_committee_id, :integer
  end
end
