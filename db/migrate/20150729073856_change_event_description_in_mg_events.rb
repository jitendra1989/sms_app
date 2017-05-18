class ChangeEventDescriptionInMgEvents < ActiveRecord::Migration
   def up
    change_column :mg_events, :event_description, :text
  end

  def down
    change_column :mg_events, :event_description, :string
  end
end
