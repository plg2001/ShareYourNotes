class AddAddedToFavoritesAtToNotes < ActiveRecord::Migration[6.1]
  def change
    add_column :notes, :added_to_favorites_at, :datetime
  end
end
