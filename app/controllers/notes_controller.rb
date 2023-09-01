require 'google_drive'
require "googleauth"
require 'convert_api'

class NotesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:index, :search, :show]
  
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

    if params[:topics].present?
      topic = params[:topics]
      topic_ids = Topic.where(name: topic).pluck(:id)
      @notes = @notes.joins(:note_topics).where(note_topics: { topic_id: topic_ids })
    end

    if params[:tags].present?
      tag = params[:tags]
      tag_ids = Tag.where(name: tag).pluck(:id)
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

    if params[:format].present?
      file_extension = params[:format]
      if file_extension == "appunti"
        @notes = @notes.where("LOWER(format) = ? OR LOWER(format) = ?", ".pdf", ".docx")
      elsif file_extension == "video"
        @notes = @notes.where("LOWER(format) = ? OR LOWER(format) = ? OR LOWER(format) = ?", ".mp4", ".avi", ".mov")
      end
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
    flash[:notice] = 'Nota aggiunta ai preferiti'
    redirect_to request.referer || root_path
  end
  

  def remove_favourite
    note = Note.find(params[:note_id])
    current_user.favourite_notes.delete(note)
    if request.referer.include?('search')
      flash[:notice] = 'Nota eliminata dai preferiti.'
      redirect_to request.referer || root_path
    elsif request.referer.include?('favourite')
      flash[:notice] = 'Nota eliminata dai preferiti.'
      redirect_to request.referer || root_path
    else
      flash[:notice] = 'Nota eliminata dai preferiti.'
      redirect_to request.referer || root_path
    end
  end

  

  def show
    @note = Note.find(params[:id])
    @comment = Comment.new
    

    file_extension = @note.format

    google_id = 0
    google_drive_link = @note.google_drive_link

    if file_extension == ".pdf"
      google_id = google_drive_link.match(/\/file\/d\/(.+?)\//)[1]  
    end

    if file_extension == ".docx"
      google_id = google_drive_link.match(/\/document\/d\/(.+?)\//)[1]  
    end
    
    
    if user_signed_in? 
      if (@visualizzazione = Visualizzazione.find_by(note_id: @note.id, user_id: current_user.id)) == nil
        @note.visualizzaziones.create(user: current_user)
      end
    end
    
    if params[:code] != nil
      redirect_uri = URI.parse("http://localhost:3000/notes/#{@note.id}")
      redirect_uri.query = URI.encode_www_form({ user_required_format: params[:user_required_format] })

      user_credentials = Google::Auth::UserRefreshCredentials.new(
        client_id: "806281785375-kivi2j1putaq08gnv7c84bsg1edps6p1.apps.googleusercontent.com",
        client_secret: "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",
        scope: [
          "https://www.googleapis.com/auth/drive",
          "https://spreadsheets.google.com/feeds/",
        ],
        redirect_uri: redirect_uri.to_s
      ) 
      
      if params[:user_required_format] != nil 
        user_required_format = params[:user_required_format]
      end

      user_credentials.code = params[:code]
      user_credentials.fetch_access_token!
      session = GoogleDrive::Session.from_credentials(user_credentials)
      file = session.file_by_url(@note.google_drive_link)

      if file_extension == ".pdf"      
        if user_required_format == "docx"
          ConvertApi.config.api_secret = 'aTSx7qLnIcyq8oDe'
          result = ConvertApi.convert('docx', { File: file.web_content_link }, from_format: 'pdf')
        end
      end
  
      if file_extension == ".docx" 
        if user_required_format == "pdf"
          ConvertApi.config.api_secret = 'aTSx7qLnIcyq8oDe'
          result = ConvertApi.convert('pdf', { File: file.web_content_link }, from_format: 'docx')
        end
      end
      
      io = nil
      if result != nil
        io = result.file.io
      end

      folder_name = "ShareYourNotes"
      existing_folder = session.collection_by_title(folder_name)
      if existing_folder
        if folder_in_trash?(existing_folder)
          existing_folder = session.create_folder(folder_name)
        end 
        if io != nil 
          uploaded_file = existing_folder.upload_from_file(io.path,@note.name,convert: false)
        else
          temp_file = open("https://drive.google.com/uc?id=#{google_id}")
          path_file = temp_file.path
          uploaded_file = existing_folder.upload_from_file(path_file,@note.name,convert: false)
        end
      
        redirect_to "http://localhost:3000/notes/#{@note.id}",alert: 'Upload sul tuo google drive effettuato correttamente.'

      else
        new_folder = session.create_folder(folder_name)
      
        if io != nil 
          uploaded_file = new_folder.upload_from_file(io.path,@note.name,convert: false)
        else
          temp_file = open("https://drive.google.com/uc?id=#{google_id}")
          path_file = temp_file.path
          uploaded_file = new_folder.upload_from_file(path_file,@note.name,convert: false)
        end
      
        redirect_to "http://localhost:3000/notes/#{@note.id}" ,alert: 'Upload sul tuo google drive effettuato correttamente.'
      end
    end
  end
  


  def new
    @note = Note.new

    if params[:code] != nil
      current_user.update!(google_drive_refresh_token: params[:code])
      current_user.save
    end
  end

  def create

    if params[:file_id] != nil && params[:file_name] != nil
      file_name = params[:note][:name]
      description = params[:note][:description]
      @note = Note.new(name: file_name, description: description)
      @note.user = current_user
      @note.tags = Tag.where(id: params[:note][:tag_ids])
      @note.topics = Topic.where(id: params[:note][:topic_ids])
      @note.format = File.extname(file_name)
      file_id = params[:file_id]
      
      temp_file = open("https://drive.google.com/uc?id=#{file_id}")
      path_file = temp_file.path

      session = GoogleDrive::Session.from_config("config.json")
      destination_folder = session.collection_by_url("https://drive.google.com/drive/folders/1zJPM2hoIzMzuvfefRvQM8NXHee5pOfhL?hl=it")

    
      
      uploaded_file = destination_folder.upload_from_file(path_file,file_name,convert: false)


      @note.faculty_id = params[:note][:faculty_id] unless params[:note][:faculty_id].blank?
      if file_name.length > 0 && description.length > 0 && @note.tags.length > 0 && @note.topics.length > 0 && @note.faculty_id != nil

    
          if uploaded_file 
  
            file_url = uploaded_file.human_url
            @note.google_drive_link = file_url

          else
            render :new, alert: 'Si è verificato un errore durante il caricamento del file'
          end
          
          if @note.save
            redirect_to @note, notice: "L'appunto è stato correttamente caricato"
          else
            render :new, alert: "Si è verificato un errore durante il caricamento dell'appunto"
          end
        else

          alert = ""
          if file_name.length == 0 
            alert.concat("Inserire un nome, ")
          end
          if description.length == 0 
            alert.concat("Inserire una descrizione, ")
          end
          if @note.tags.length == 0 
            alert.concat("Inserire almeno un Tag, ")
          end
          if @note.topics.length == 0 
            alert.concat("Inserire almeno un Topic, ")
          end
          if @note.faculty_id == nil
            alert.concat("Inserire una Facoltà.")
          end
          flash[:error] = alert
          render :new
        end
      
      
    else

      @note = Note.new(note_params)
      @note.user = current_user
      @note.tags = Tag.where(id: params[:note][:tag_ids])
      @note.topics = Topic.where(id: params[:note][:topic_ids])
      file = params[:file]
      name = (params[:note][:name]).to_s
      description = (params[:note][:description]).to_s

      allowed_extensions = [".pdf", ".docx", ".mp4", ".mov", ".avi"]
      if file && allowed_extensions.include?(File.extname(file.original_filename).downcase)
        
        filename = file.original_filename
        @note.format = File.extname(filename)

        tempfile = file.tempfile

        session = GoogleDrive::Session.from_config("config.json")
        destination_folder = session.collection_by_url("https://drive.google.com/drive/folders/1zJPM2hoIzMzuvfefRvQM8NXHee5pOfhL?hl=it")
        @note.faculty_id = params[:note][:faculty_id] unless params[:note][:faculty_id].blank?


        if name.length > 0 && description.length > 0 && @note.tags.length > 0 && @note.topics.length > 0 && @note.faculty_id != nil
          uploaded_file = destination_folder.upload_from_file(tempfile.path,filename,convert: false)     
          if uploaded_file 
            file_url = uploaded_file.human_url
            @note.google_drive_link = file_url

          else
            render :new, alert: 'Si è verificato un errore durante il caricamento del file'
          
          end 

          if @note.save
            redirect_to @note, notice: "L'appunto è stato correttamente caricato"
          else
            render :new, alert: "Si è verificato un errore durante il caricamento dell'appunto"
          end
        else

          alert = ""
          if name.length == 0 
            alert.concat("Inserire un nome, ")
          end
          if description.length == 0 
            alert.concat("Inserire una descrizione, ")
          end
          if @note.tags.length == 0 
            alert.concat("Inserire almeno un Tag, ")
          end
          if @note.topics.length == 0 
            alert.concat("Inserire almeno un Topic, ")
          end
          if @note.faculty_id == nil
            alert.concat("Inserire una Facoltà.")
          end
          flash[:error] = alert
          render :new
        end
        
      else
        flash[:error] = "Formato del file non consentito. Sono consentiti solo file PDF, DOCX, MP4, MOV e AVI."
        render :new
      end
    end
  end

  
  

  def download_file
    @note = Note.find(params[:id])
    @note.increment_download_count
    file_extension= @note.format
    session = GoogleDrive::Session.from_config("config.json")
    file = session.file_by_url(@note.google_drive_link)
    


    if params[:format] != nil
      user_required_format = params[:format]
    end

    if file_extension == ".pdf" 
      if user_required_format == "pdf"
        redirect_to file.web_content_link
      end

      if user_required_format == "docx"
        ConvertApi.config.api_secret = 'aTSx7qLnIcyq8oDe'
        result = ConvertApi.convert('docx', { File: file.web_content_link }, from_format: 'pdf')
        redirect_to result.files[0].url
      end
    end

    if file_extension == ".docx" 
      if user_required_format == "pdf"
        ConvertApi.config.api_secret = 'aTSx7qLnIcyq8oDe'
        result = ConvertApi.convert('pdf', { File: file.web_content_link }, from_format: 'docx')
        redirect_to result.files[0].url
      end

      if user_required_format == "docx"
        redirect_to file.web_content_link
      end
    end
 
    

  
   
    
  end

  def deseleziona
    render :new, alert: "File deselezionato"
  end

  def update_rating
    @note = Note.find(params[:id])
    @user = User.find(@note.user.id)


    if (@create_rating = CreateRating.find_by(note_id: @note.id, user_id: current_user.id)) == nil
      @create_rating = CreateRating.create!(note_id: @note.id, user_id: current_user.id, rating: params[:note][:rating])

    else
      @create_rating.update(rating: params[:note][:rating])
    end
    


    average_rating = CreateRating.where(note_id: @note.id).average(:rating)
    @note.update(rating: average_rating)

    setUserRating(@user)

    flash[:notice] = 'Valutazione aggiunta con successo!'
    redirect_to request.referer || root_path
    
  end

  def setUserRating(user)
    sum_ratings = 0
      i = 0
      user.notes.each do |note|
        sum_ratings += note.rating
        i += 1
      end
      if i == 0
        i = 1
      end
      average_rating = sum_ratings / i

      user.update(rating: average_rating)
  end

  def delete
    note = Note.find(params[:id])
    notetags = NoteTag.where(note_id: params[:id])
    notetags.delete_all
    notetopics = NoteTopic.where(note_id: params[:id])
    notetopics.delete_all
    favourites = Favourite.where(note_id: params[:id])
    favourites.delete_all
    createrating = CreateRating.where(note_id: params[:id])
    createrating.delete_all
    comments = Comment.where(note_id: params[:id])
    comments.delete_all
    views = Visualizzazione.where(note_id: params[:id])
    views.delete_all
    delete_G_Drive(note.google_drive_link)
    user = note.user
    note.delete
    setUserRating(user)
    redirect_to my_notes_path, notice: 'La nota è stata cancellata con successo.'
  end

  def delete_G_Drive(google_drive_link)
    session = GoogleDrive::Session.from_config("config.json")
    file_id = google_drive_link.match(/\/file\/d\/(.+?)\//)[1]
    file = session.file_by_id(file_id)
    file.delete
  end


  def recenti
    @visualizzazioni_recenti = current_user.visualizzaziones.order(created_at: :desc).limit(10)
  end
  
  def download_on_my_gd
    @note = Note.find(params[:id])
    google_id = params[:google_id]
    file_extension = @note.format

    if params[:format] != nil
      user_required_format = params[:format]
    end

    

    if current_user.google_drive_refresh_token != nil && current_user.provider == "google_oauth2"

      user_credentials = Google::Auth::UserRefreshCredentials.new(
        client_id: "806281785375-kivi2j1putaq08gnv7c84bsg1edps6p1.apps.googleusercontent.com",
        client_secret: "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",
        scope: ['https://www.googleapis.com/auth/drive'],
        refresh_token: current_user.google_drive_refresh_token,
      )

      
      folder_name = "ShareYourNotes"
      session = GoogleDrive::Session.from_credentials(user_credentials)
      file = session.file_by_url(@note.google_drive_link)
      
      if file_extension == ".pdf"      
        if user_required_format == "docx"
          ConvertApi.config.api_secret = 'aTSx7qLnIcyq8oDe'
          result = ConvertApi.convert('docx', { File: file.web_content_link }, from_format: 'pdf')
        end
      end
  
      if file_extension == ".docx" 
        if user_required_format == "pdf"
          ConvertApi.config.api_secret = 'aTSx7qLnIcyq8oDe'
          result = ConvertApi.convert('pdf', { File: file.web_content_link }, from_format: 'docx')
        end
      end

      io = nil
      if result != nil
        io = result.file.io
      end
      existing_folder = session.collection_by_title(folder_name)
      
      
      if existing_folder
        if folder_in_trash?(existing_folder)
          existing_folder = session.create_folder(folder_name)
        end
        if io != nil 
          uploaded_file = existing_folder.upload_from_file(io.path,@note.name,convert: false)
        else
          temp_file = open("https://drive.google.com/uc?id=#{google_id}")
          path_file = temp_file.path
          uploaded_file = existing_folder.upload_from_file(path_file,@note.name,convert: false)
        end
       

        redirect_to "http://localhost:3000/notes/#{@note.id}",alert: 'Upload sul tuo google drive effettuato correttamente'

      else
        new_folder = session.create_folder(folder_name)
      
        if io != nil 
          uploaded_file = new_folder.upload_from_file(io.path,@note.name,convert: false)
        else
          temp_file = open("https://drive.google.com/uc?id=#{google_id}")
          path_file = temp_file.path
          uploaded_file = new_folder.upload_from_file(path_file,@note.name,convert: false)
        end

        redirect_to "http://localhost:3000/notes/#{@note.id}" ,alert: 'Upload sul tuo google drive effettuato correttamente'

      end
          
    else
      redirect_uri = URI.parse("http://localhost:3000/notes/#{@note.id}")
      redirect_uri.query = URI.encode_www_form({ user_required_format: user_required_format })

      user_credentials = Google::Auth::UserRefreshCredentials.new(
        client_id: "806281785375-kivi2j1putaq08gnv7c84bsg1edps6p1.apps.googleusercontent.com",
        client_secret: "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",
        scope: [
          "https://www.googleapis.com/auth/drive",
          "https://spreadsheets.google.com/feeds/",
        ],
        redirect_uri: redirect_uri.to_s
      )
      auth_url = user_credentials.authorization_uri
      redirect_to auth_url.to_s 

    end
  end

  def folder_in_trash?(folder)

    return folder.trashed?
  rescue Google::Apis::ClientError => e
    return true if e.status_code == 404
  
    return false
  end

  def suggested
    favourite = current_user.favourite_notes.includes(:note_topics, :note_tags)
    favourite_topics = favourite.flat_map(&:note_topics).map(&:topic_id)
    favourite_tags = favourite.flat_map(&:note_tags).map(&:tag_id)

    @suggested_notes = Note.joins(:note_topics, :note_tags)
                           .where('note_topics.topic_id IN (?) OR note_tags.tag_id IN (?)', favourite_topics, favourite_tags)
                           .where.not(id: favourite.pluck(:id))
                           .where.not(user_id: current_user.id)
                           .distinct
  end

  def best
    @best_notes = Note.where("rating <= 5").order(rating: :desc)
    @topic_ids_union = []
    @tag_ids_union = []
    @notes_union = []

    @best_notes.each do |note|
      topic_id = note.note_topics.first.topic_id
      tag_id = note.note_tags.first.tag_id
      index = @topic_ids_union.index(topic_id)
      if index && @tag_ids_union[index] == tag_id
        @notes_union[index] << note
      else
        @topic_ids_union << topic_id
        @tag_ids_union << tag_id
        @notes_union << [note]
      end
    end
  end


  def edit
    @note = current_user.notes.find(params[:id])

    @tags = Tag.all
    @topics = Topic.all

  end


  def update
    @note = current_user.notes.find(params[:id])
    if(params[:note][:tag_ids] != nil && params[:note][:topic_ids] && params[:note][:name].length > 0 && params[:note][:description].length > 0)
      if @note.update(note_params)     
        @note.tags = Tag.where(id: params[:note][:tag_ids])
        @note.topics = Topic.where(id: params[:note][:topic_ids])
        redirect_to @note, notice: 'Appunto aggiornato con successo.'
      else
        render :edit
      end
    else
      flash[:error] = "Compilare tutti i campi"
      render :edit
    end
  end

  def note_params
    params.require(:note).permit(:name, :description, :user_id, :google_drive_link, :faculty_id)
  end  


  def video_download
    @note = Note.find(params[:id])
    @note.increment_download_count
  
    session = GoogleDrive::Session.from_config("config.json")
    file = session.file_by_url(@note.google_drive_link)

    redirect_to file.web_content_link
  end

 
  
end
