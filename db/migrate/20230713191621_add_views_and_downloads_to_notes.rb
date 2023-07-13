class AddViewsAndDownloadsToNotes < ActiveRecord::Migration[6.1]
  def change
    add_column :notes, :views, :integer
    add_column :notes, :downloads, :integer
  end
end
