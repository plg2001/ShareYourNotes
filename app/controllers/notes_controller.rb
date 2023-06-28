class NotesController < ApplicationController
  def index
    order = params[:order] == 'desc' ? 'name DESC' : 'name ASC'
    @notes = Note.order(order)
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
  
    if params[:uploaded_after].present?
      uploaded_after_date = Date.parse(params[:uploaded_after])
      @notes = @notes.where("uploaded_at >= ?", uploaded_after_date.beginning_of_day)
    end
  
    if params[:uploaded_before].present?
      uploaded_before_date = Date.parse(params[:uploaded_before])
      @notes = @notes.where("uploaded_at <= ?", uploaded_before_date.end_of_day)
    end
  
    order = params[:order] == 'desc' ? 'name DESC' : 'name ASC'
    @notes = @notes.order(order)
  
    render 'search'
  end
  
  def show
    @note = Note.find(params[:id])
  end
  
  def new
    @note = Note.new
    @tags = Tag.all
    @topics = Topic.all
  end

  def create
    @note = Note.new(note_params)
    @note.tags = Tag.where(id: params[:note][:tag_ids])
    @note.topics = Topic.where(id: params[:note][:topic_ids])
  
    if @note.save
      
      redirect_to @note, notice: 'Note was successfully created.'
    else
      render :new
    end
  end
  
  
  def note_params
    params.require(:note).permit(:name, :description)
  end  

end
