class AddLinkToNotes < ActiveRecord::Migration[6.1]
  def change
    add_column :notes, :google_drive_link, :string
  end
end
