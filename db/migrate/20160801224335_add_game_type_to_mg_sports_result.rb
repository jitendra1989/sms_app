class AddGameTypeToMgSportsResult < ActiveRecord::Migration
  def change
    add_column :mg_sports_results, :game_type, :string
  end
end
