class AddRatingToNotes < ActiveRecord::Migration[6.1]
  def change
    add_column :notes, :rating, :integer, null: false, default: 0
  end
end
