class NotesController < ApplicationController
  def index
    @notes = Note.all
  end

  def search
    @notes = Note.where("name LIKE ?", "%#{params[:search]}%")
  
    if params[:topic].present?
      topic = Topic.find_by(name: params[:topic])
      @notes = @notes.joins(:note_topics).where(note_topics: { topic: topic })
    end
  
    if params[:tag].present?
      tag = Tag.find_by(name: params[:tag])
      @notes = @notes.joins(:note_tags).where(note_tags: { tag: tag })
    end
  
    render 'search'
  end    
   
end
