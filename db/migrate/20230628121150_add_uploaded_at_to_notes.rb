class AddUploadedAtToNotes < ActiveRecord::Migration[6.1]
  def change
    add_column :notes, :uploaded_at, :datetime
  end
end
