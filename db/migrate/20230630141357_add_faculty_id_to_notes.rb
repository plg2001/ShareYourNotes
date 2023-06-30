class AddFacultyIdToNotes < ActiveRecord::Migration[6.1]
  def change
    add_reference :notes, :faculty, null: true, foreign_key: true
  end
end

