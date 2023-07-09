class RemoveAddedToFavoritesAtFromNotes < ActiveRecord::Migration[6.1]
  def change
    remove_column :notes, :added_to_favorites_at, :datetime
  end
end
