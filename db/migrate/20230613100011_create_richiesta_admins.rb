class CreateRichiestaAdmins < ActiveRecord::Migration[6.1]
  def change
    create_table :richiesta_admins do |t|
      t.references :user, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
