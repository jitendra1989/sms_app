class ChangeDescriptionInMgAlbums < ActiveRecord::Migration
    def up
    change_column :mg_albums, :description, :text
  end

  def down
    change_column :mg_albums, :description, :string
  end
end

