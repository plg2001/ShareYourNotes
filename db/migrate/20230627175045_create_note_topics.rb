class CreateNoteTopics < ActiveRecord::Migration[6.1]
  def change
    create_table :note_topics do |t|
      t.references :note, null: false, foreign_key: true
      t.references :topic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
