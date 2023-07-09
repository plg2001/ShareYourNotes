class ChangeDefaultAddedToFavoritesAtInFavourites < ActiveRecord::Migration[6.1]
  def up
    change_column_default :favourites, :added_to_favorites_at, nil
  end

  def down
    change_column_default :favourites, :added_to_favorites_at, "2023-07-09 09:00:31"
  end
end
