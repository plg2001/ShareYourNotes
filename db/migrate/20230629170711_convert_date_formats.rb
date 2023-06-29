class ConvertDateFormats < ActiveRecord::Migration[6.1]
  def up
    Note.find_each do |note|
      uploaded_at = note.uploaded_at.to_date
      note.update(uploaded_at: uploaded_at.strftime("%d-%m-%Y"))
    end
  end

  def down
    Note.find_each do |note|
      uploaded_at = Date.strptime(note.uploaded_at, "%d-%m-%Y")
      note.update(uploaded_at: uploaded_at)
    end
  end
end
