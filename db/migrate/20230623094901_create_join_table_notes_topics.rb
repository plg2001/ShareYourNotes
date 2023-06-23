class CreateJoinTableNotesTopics < ActiveRecord::Migration[6.1]
  def change
    create_join_table :notes, :topics do |t|
      # t.index [:note_id, :topic_id]
      # t.index [:topic_id, :note_id]
    end
  end
end
