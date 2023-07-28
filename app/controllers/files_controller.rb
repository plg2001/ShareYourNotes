# app/controllers/files_controller.rb

require 'google_drive'
require "googleauth"

class FilesController < ApplicationController
  def index
    # Aggiungi qui il tuo codice per ottenere i titoli dei file da Google Drive

    
    

    if current_user.google_drive_refresh_token != nil 
      user_credentials = Google::Auth::UserRefreshCredentials.new(
        client_id: "806281785375-kivi2j1putaq08gnv7c84bsg1edps6p1.apps.googleusercontent.com",
        client_secret: "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",
        scope: ['https://www.googleapis.com/auth/drive'],
        refresh_token: current_user.google_drive_refresh_token,
      )

      # Crea il client per l'API Google Drive
      drive_service = Google::Apis::DriveV3::DriveService.new
      drive_service.authorization = user_credentials

      # Esegui la query per ottenere la lista dei file
      @files = drive_service.list_files(fields: 'files(name, id, webViewLink)').files
    end
  end

    
end
