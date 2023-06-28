class NotesController < ApplicationController
    def index
      @notes = Note.all
    end
  
    def search
      @notes = Note.where("name LIKE ?", "%#{params[:search]}%")
  
      if params[:topic].present?
        @notes = @notes.where(topic: params[:topic])
      end
  
      if params[:tag].present?
        @notes = @notes.joins(:tags).where("tags.name = ?", params[:tag])
      end
  
      render 'search'
    end
  
    def create
      @note = Note.new(
        name: "Appunti Analisi 1",
        description: "Appunti presi durante il corso dell'anno 2010/2011"
      )
      @topic = Topic.find_or_create_by(name: "Ingegneria Informatica e Automatica")
      @tag = Tag.find_or_create_by(name: "Analisi 1")
  
      @note.topic = @topic
      @note.tags << @tag
  
      if @note.save
        redirect_to notes_path, notice: "Nota creata con successo."
      else
        render :new
      end
    end
  end
