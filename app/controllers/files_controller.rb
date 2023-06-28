require 'google_drive'

class FilesController < ApplicationController
  def upload
    file = params[:file]
    filename = file.original_filename
    tempfile = file.tempfile

    session = GoogleDrive::Session.from_service_account_key("config.json")
    session = GoogleDrive::Session.from_config("config.json")
    root_folder = session.root_folder
    folders = root_folder.subfolders
    target_folder = folders.find { |folder| folder.title == "ShareYourNotes" }

    uploaded_file = target_folder.upload_from_file(tempfile.path, filename)

    if uploaded_file
      file_url = uploaded_file.human_url
      puts file_url
      # Salva l'URL del file nel database o fai altre operazioni necessarie
      # ad esempio, se hai un modello "File", potresti fare:
      # uploaded_file = File.create(url: file_url)

      redirect_to root_path, notice: 'Il file è stato caricato con successo su Google Drive.'
    else
      redirect_to root_path, alert: 'Si è verificato un errore durante il caricamento del file su Google Drive.'
    end
  end
end