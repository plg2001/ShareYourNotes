# app/controllers/files_controller.rb

require 'google_drive'

class FilesController < ApplicationController
  def index
    # Aggiungi qui il tuo codice per ottenere i titoli dei file da Google Drive
    session = GoogleDrive::Session.from_config("config1.json")
    @files = session.files
  end
end
