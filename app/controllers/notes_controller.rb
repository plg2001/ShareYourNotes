require 'google_drive'

class NotesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:index, :search, :show]

  def index
    order = params[:order] == 'desc' ? 'name DESC' : 'name ASC'
    @notes = Note.order(order)
  end
  
  def search
    @notes = Note.all
  
    if params[:search].present?
      @notes = @notes.where("name LIKE ?", "%#{params[:search]}%")
    end
  
    if params[:topic].present?
      topics = params[:topic]
      topic_ids = Topic.where(name: topics).pluck(:id)
      @notes = @notes.joins(:note_topics).where(note_topics: { topic_id: topic_ids })
    end
  
    if params[:tag].present?
      tags = params[:tag]
      tag_ids = Tag.where(name: tags).pluck(:id)
      @notes = @notes.joins(:note_tags).where(note_tags: { tag_id: tag_ids })
    end
  
    if params[:uploaded_after].present?
      uploaded_after_date = Date.parse(params[:uploaded_after])
      @notes = @notes.where("uploaded_at >= ?", uploaded_after_date.beginning_of_day)
    end
  
    if params[:uploaded_before].present?
      uploaded_before_date = Date.parse(params[:uploaded_before])
      @notes = @notes.where("uploaded_at <= ?", uploaded_before_date.end_of_day)
    end
  
    if params[:faculty].present?
      faculty = Faculty.find_by(id: params[:faculty])
      @notes = @notes.where(faculty: faculty)
    end
  
    if params[:user_search].present?
      users = User.where("name LIKE ?", "%#{params[:user_search]}%")
      user_ids = users.pluck(:id)
      @notes = @notes.where(user_id: user_ids)
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
    @note.user = current_user
    @note.tags = Tag.where(id: params[:note][:tag_ids])
    @note.topics = Topic.where(id: params[:note][:topic_ids])
    
    file = params[:file]
    filename = file.original_filename
    tempfile = file.tempfile

    session = GoogleDrive::Session.from_config("config.json")
    destination_folder = session.collection_by_url("https://drive.google.com/drive/folders/1zJPM2hoIzMzuvfefRvQM8NXHee5pOfhL?hl=it")
    uploaded_file = destination_folder.upload_from_file(tempfile.path,filename,convert: false)

    if uploaded_file 
      file_url = uploaded_file.human_url
      @note.google_drive_link = file_url
      
      
      @note.facolta_id = params[:note][:facolta_id] unless params[:note][:facolta_id].blank?

      if @note.save
        redirect_to @note, notice: "L'appunto è stato correttamente caricato"
      else
        render :new, alert: 'Si è verificato un errore durante il caricamento del file'
      end
    else
      render :new, alert: 'Si è verificato un errore durante il caricamento del file'
    end
  end
  
  
  def note_params
    params.require(:note).permit(:name, :description,:google_drive_link, :faculty_id)
  end  


  def download_file
    @note = Note.find(params[:id])
    session = GoogleDrive::Session.from_config("config.json")
    file = session.file_by_url(@note.google_drive_link)


    redirect_to file.web_content_link
  end

end
