class ChangeDescriptionInMgNotifications < ActiveRecord::Migration
   def up
    change_column :mg_notifications, :description, :text
  end

  def down
    change_column :mg_notifications, :description, :string
  end
end
