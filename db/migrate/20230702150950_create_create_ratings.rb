class CreateCreateRatings < ActiveRecord::Migration[6.1]
  def change
    create_table :create_ratings do |t|
      t.references :note, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :rating, null: false, default: 0

      t.timestamps
    end
  end
end
