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
  
    if params[:user_search].present?
      users = User.where("username LIKE ?", "%#{params[:user_search]}%")
      user_ids = users.pluck(:id)
      @notes = @notes.where(user_id: user_ids)
    end    

    if params[:faculty].present?
      faculty = Faculty.find_by(id: params[:faculty])
      @notes = @notes.where(faculty: faculty)
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

    if params[:rating].present?
      rating = params[:rating].to_i
      @notes = @notes.where("rating >= ?", rating)
    end  
    
    if params[:after].present?
      after_date = Date.parse(params[:after])
      @notes = @notes.where("uploaded_at >= ?", after_date.beginning_of_day)
    end
  
    if params[:before].present?
      before_date = Date.parse(params[:before])
      @notes = @notes.where("uploaded_at <= ?", before_date.end_of_day)
    end
  
    order = params[:order] == 'desc' ? 'name DESC' : 'name ASC'
    @notes = @notes.order(order)
  
    render 'search'
  end
  
  def favourite
    @favourite_notes = current_user.favourite_notes.includes(:note_topics, :note_tags)
    @note_topics = NoteTopic.where(note_id: @favourite_notes.pluck(:id)).group_by(&:topic_id)
    @note_tags = NoteTag.where(note_id: @favourite_notes.pluck(:id)).group_by(&:tag_id)
  end

  def add_favourite
    note = Note.find(params[:note_id])
    favourite = current_user.favourites.find_or_initialize_by(note: note)
    favourite.added_to_favorites_at = Time.current
    favourite.save
    redirect_to search_path, notice: 'Nota aggiunta ai preferiti'
  end
  

  def remove_favourite
    note = Note.find(params[:note_id])
    current_user.favourite_notes.delete(note)
    if request.referer.include?('search')
      redirect_to search_path, notice: 'Nota eliminata dai preferiti.'
    elsif request.referer.include?('favourite')
      redirect_to favourite_path, notice: 'Nota eliminata dai preferiti.'
    else
      redirect_to favourite_path, notice: 'Nota eliminata dai preferiti.'
    end
  end

  def note_params
    params.require(:note).permit(:title, :content, :user_id, favourite_note_ids: [])
  end  

  def show
    @note = Note.find(params[:id])
    @comment = Comment.new

    if (@visualizzazione = Visualizzazione.find_by(note_id: @note.id, user_id: current_user.id)) == nil
      @note.visualizzaziones.create(user: current_user)
    end
    
    @note.increment_view_count

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
    @note.increment_download_count
    session = GoogleDrive::Session.from_config("config.json")
    file = session.file_by_url(@note.google_drive_link)


    redirect_to file.web_content_link
  end


  def update
    @note = Note.find(params[:id])
    

    if (@create_rating = CreateRating.find_by(note_id: @note.id, user_id: current_user.id)) == nil
      @create_rating = CreateRating.create!(note_id: @note.id, user_id: current_user.id, rating: params[:note][:rating])

    else
      @create_rating.update(rating: params[:note][:rating])
      @toast = :success
    end
    

    average_rating = CreateRating.where(note_id: @note.id).average(:rating)
    @note.update(rating: average_rating)

    render :show
  end

  def delete
    note = Note.find(params[:id])
    notetags = NoteTag.where(note_id: params[:id])
    notetags.delete_all
    notetopics = NoteTopic.where(note_id: params[:id])
    notetopics.delete_all
    favourites = Favourite.where(note_id: params[:id])
    favourite.delete_all
    createrating = CreateRating.where(note_id: params[:id])
    createrating.delete_all
    comments = Comment.where(note_id: params[:id])
    comments.delete_all
    view = Visualizzazione.where(note_id: params[:id])
    view.delete_all
    note.delete
    redirect_to my_notes_path, notice: 'La nota è stata cancellata con successo.'
  end

  def recenti
    @visualizzazioni_recenti = current_user.visualizzaziones.order(created_at: :desc).limit(10)
  end
  

end
