class CreateNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :notes do |t|
      t.integer 'id_n' #Id univoco per l'appunto
      t.string 'user' #Utente che ha pubblicato l'appunto
      t.string 'rating' #Valutazione dell'appunto
      t.text 'text' #Contenuto dell'appunto
      t.datetime 'release_date' 
      t.timestamps
    end
  end
end
