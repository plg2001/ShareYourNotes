class NotesController < ApplicationController
    def index
        @notes = Note.all
    end
    
    def search
        @notes = Note.where("name LIKE ?", "%#{params[:search]}%")
        render 'search'
    end
end
