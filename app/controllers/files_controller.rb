# app/controllers/files_controller.rb

require 'google_drive'
require "googleauth"

class FilesController < ApplicationController
  def index
    @files = nil

    if params[:code] != nil
      user_credentials = Google::Auth::UserRefreshCredentials.new(
        client_id: "806281785375-kivi2j1putaq08gnv7c84bsg1edps6p1.apps.googleusercontent.com",
        client_secret: "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",
        scope: [
          "https://www.googleapis.com/auth/drive",
          "https://spreadsheets.google.com/feeds/",
        ],
        redirect_uri: "http://localhost:3000/files"
      ) 
      user_credentials.code = params[:code]
      user_credentials.fetch_access_token!
      session = GoogleDrive::Session.from_credentials(user_credentials)

      @files = session.files
    end

    if current_user.google_drive_refresh_token != nil && current_user.provider == "google_oauth2"
      user_credentials = Google::Auth::UserRefreshCredentials.new(
        client_id: "806281785375-kivi2j1putaq08gnv7c84bsg1edps6p1.apps.googleusercontent.com",
        client_secret: "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",
        scope: ['https://www.googleapis.com/auth/drive'],
        refresh_token: current_user.google_drive_refresh_token,
      )

      session  = GoogleDrive::Session.from_credentials(user_credentials)
      @files = session.files
      
    elsif @files == nil
      user_credentials = Google::Auth::UserRefreshCredentials.new(
        client_id: "806281785375-kivi2j1putaq08gnv7c84bsg1edps6p1.apps.googleusercontent.com",
        client_secret: "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",
        scope: [
          "https://www.googleapis.com/auth/drive",
          "https://spreadsheets.google.com/feeds/",
        ],
        redirect_uri: "http://localhost:3000/files"
      )
      auth_url = user_credentials.authorization_uri
      redirect_to auth_url.to_s 
    end
  end

    
end
